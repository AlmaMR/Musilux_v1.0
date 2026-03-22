import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';
import '../features/catalog/data/api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  String get _baseUrl => ApiConstants.baseUrl;

  // ── Registro ────────────────────────────────────────────
  Future<AuthResult> register({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await _saveSession(data['token'], data['user']);
        return AuthResult.success(data['token'], AuthUser.fromJson(data['user']));
      }

      final message = _extractError(data);
      return AuthResult.failure(message);
    } catch (e) {
      return AuthResult.failure('No se pudo conectar al servidor.');
    }
  }

  // ── Inicio de sesión ─────────────────────────────────────
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveSession(data['token'], data['user']);
        return AuthResult.success(data['token'], AuthUser.fromJson(data['user']));
      }

      final message = _extractError(data);
      return AuthResult.failure(message);
    } catch (e) {
      return AuthResult.failure('No se pudo conectar al servidor.');
    }
  }

  // ── Cierre de sesión ─────────────────────────────────────
  Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (_) {
        // Si falla la llamada, igual borramos la sesión local
      }
    }
    await _clearSession();
  }

  // ── Sesión persistida ─────────────────────────────────────
  Future<void> _saveSession(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
    // Propagamos el token al servicio de productos del admin
    ProductService.authToken = token;
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    ProductService.authToken = null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<AuthUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return AuthUser.fromJson(jsonDecode(raw));
  }

  /// Restaura el token en memoria al iniciar la app.
  Future<bool> restoreSession() async {
    final token = await getToken();
    if (token == null) return false;
    ProductService.authToken = token;
    return true;
  }

  // ── Utilidad ──────────────────────────────────────────────
  String _extractError(Map<String, dynamic> data) {
    if (data['errors'] != null) {
      final errors = data['errors'] as Map<String, dynamic>;
      return errors.values
          .expand((e) => e is List ? e : [e])
          .join('\n');
    }
    return data['message'] ?? 'Error desconocido.';
  }
}

class AuthResult {
  final bool success;
  final String? token;
  final AuthUser? user;
  final String? error;

  AuthResult._({required this.success, this.token, this.user, this.error});

  factory AuthResult.success(String token, AuthUser user) =>
      AuthResult._(success: true, token: token, user: user);

  factory AuthResult.failure(String error) =>
      AuthResult._(success: false, error: error);
}

class AuthUser {
  final String id;
  final String nombre;
  final String email;

  AuthUser({required this.id, required this.nombre, required this.email});

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id']?.toString() ?? '',
        nombre: json['nombre']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
      );
}
