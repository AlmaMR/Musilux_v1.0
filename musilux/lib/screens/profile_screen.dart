import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';
import '../services/auth_service.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class _RoleOption {
  final int id;
  final String nombre;
  _RoleOption({required this.id, required this.nombre});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  bool _isAuthenticated = false;
  bool _isLoginView = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Controllers
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

  // Roles
  List<_RoleOption> _roles = [];
  int? _selectedRolId;
  bool _loadingRoles = false;

  // Usuario autenticado
  AuthUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final user = await _authService.getUser();
    if (user != null && mounted) {
      setState(() {
        _isAuthenticated = true;
        _currentUser = user;
      });
    }
  }

  Future<void> _loadRoles() async {
    if (_loadingRoles) return;
    setState(() => _loadingRoles = true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/roles'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body);
        final list = (raw is List
            ? raw
            : (raw['data'] ?? raw['roles'] ?? [])) as List;
        final loaded = list
            .map((r) => _RoleOption(
                  id: r['id'] as int,
                  nombre: r['nombre']?.toString() ??
                      r['name']?.toString() ??
                      '',
                ))
            .toList();
        if (mounted) {
          setState(() {
            _roles = loaded;
            if (_roles.isNotEmpty) _selectedRolId = _roles.first.id;
          });
        }
      }
    } catch (_) {
      // No bloquear el formulario si los roles no cargan
    } finally {
      if (mounted) setState(() => _loadingRoles = false);
    }
  }

  Future<void> _registrarse() async {
    if (_nombresController.text.trim().isEmpty ||
        _apellidosController.text.trim().isEmpty ||
        _correoController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Completa todos los campos.');
      return;
    }
    if (_selectedRolId == null) {
      setState(() => _errorMessage = 'Selecciona un rol.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.register(
      idRol: _selectedRolId!,
      nombres: _nombresController.text.trim(),
      apellidos: _apellidosController.text.trim(),
      correo: _correoController.text.trim(),
      contrasena: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      setState(() {
        _isAuthenticated = true;
        _currentUser = result.user;
      });
    } else {
      setState(() => _errorMessage = result.error);
    }
  }

  Future<void> _iniciarSesion() async {
    if (_correoController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Completa todos los campos.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.login(
      email: _correoController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      setState(() {
        _isAuthenticated = true;
        _currentUser = result.user;
      });
    } else {
      setState(() => _errorMessage = result.error);
    }
  }

  Future<void> _cerrarSesion() async {
    await _authService.logout();
    if (!mounted) return;
    setState(() {
      _isAuthenticated = false;
      _currentUser = null;
      _isLoginView = true;
      _errorMessage = null;
      _correoController.clear();
      _passwordController.clear();
      _nombresController.clear();
      _apellidosController.clear();
    });
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Center(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _isAuthenticated
                ? _buildProfileInfo()
                : (_isLoginView ? _buildLoginForm() : _buildRegisterForm()),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // VISTA: INFORMACIÓN DEL PERFIL
  // ==========================================
  Widget _buildProfileInfo() {
    final user = _currentUser;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryPurple,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          '${user?.nombres ?? ''} ${user?.apellidos ?? ''}'.trim(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBg,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          user?.correo ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        if (user?.rol != null) ...[
          const SizedBox(height: 8),
          Chip(
            label: Text(user!.rol!),
            backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
            labelStyle: const TextStyle(color: AppColors.primaryPurple),
          ),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(),
        ),
        _buildInfoRow(
          Icons.shopping_bag_outlined,
          'Mis pedidos',
          '0 pedidos realizados',
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _cerrarSesion,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryPurple),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // VISTA: FORMULARIO DE REGISTRO
  // ==========================================
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crear Cuenta',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Únete a Musilux para realizar tus compras.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 30),

        _buildTextField('Nombres', controller: _nombresController),
        const SizedBox(height: 16),
        _buildTextField('Apellidos', controller: _apellidosController),
        const SizedBox(height: 16),
        _buildTextField(
          'Correo electrónico',
          controller: _correoController,
          isEmail: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Contraseña',
          controller: _passwordController,
          isPassword: true,
        ),
        const SizedBox(height: 16),

        // Selector de rol
        _loadingRoles
            ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : DropdownButtonFormField<int>(
                value: _selectedRolId,
                decoration: InputDecoration(
                  labelText: 'Rol',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.primaryPurple),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                hint: const Text('Selecciona un rol'),
                items: _roles
                    .map((r) => DropdownMenuItem(
                          value: r.id,
                          child: Text(r.nombre),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedRolId = v),
              ),

        const SizedBox(height: 12),
        if (_errorMessage != null) _buildError(_errorMessage!),

        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _registrarse,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: TextButton(
            onPressed: () => setState(() {
              _isLoginView = true;
              _errorMessage = null;
            }),
            child: const Text(
              '¿Ya tienes cuenta? Inicia sesión aquí',
              style: TextStyle(color: AppColors.primaryPurple),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // VISTA: FORMULARIO DE INICIO DE SESIÓN
  // ==========================================
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Iniciar Sesión',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Bienvenido de nuevo a Musilux.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 30),

        _buildTextField(
          'Correo electrónico',
          controller: _correoController,
          isEmail: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Contraseña',
          controller: _passwordController,
          isPassword: true,
        ),
        const SizedBox(height: 12),

        if (_errorMessage != null) _buildError(_errorMessage!),

        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _iniciarSesion,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Ingresar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _isLoginView = false;
                _errorMessage = null;
              });
              if (_roles.isEmpty) _loadRoles();
            },
            child: const Text(
              '¿No tienes cuenta? Regístrate aquí',
              style: TextStyle(color: AppColors.primaryPurple),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ──────────────────────────────────────────────

  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade700, fontSize: 13),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryPurple),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
      ),
    );
  }
}
