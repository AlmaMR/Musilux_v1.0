import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

/// Gestiona el estado de la conversación activa con el chatbot de IA.
/// Se registra en el árbol de widgets junto al AuthProvider.
class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  List<ChatMessage> _mensajes = [];
  bool   _enviando  = false;
  bool   _cargando  = false;
  String? _idSesion;
  String? _error;

  // ── Getters ─────────────────────────────────────────────────────────────────
  List<ChatMessage> get mensajes  => List.unmodifiable(_mensajes);
  bool              get enviando  => _enviando;
  bool              get cargando  => _cargando;
  String?           get idSesion  => _idSesion;
  String?           get error     => _error;

  // ── Enviar un mensaje ────────────────────────────────────────────────────────
  Future<void> enviarMensaje(String texto) async {
    if (texto.trim().isEmpty || _enviando) return;

    // Actualizaciones UI optimistas
    final msgUsuario = ChatMessage.local(rol: 'usuario', contenido: texto.trim());
    _mensajes.add(msgUsuario);
    _enviando = true;
    _error    = null;
    notifyListeners();

    try {
      final result = await _service.enviarMensaje(
        mensaje:   texto.trim(),
        idSesion:  _idSesion,
      );

      _idSesion = result['id_sesion'];
      _mensajes.add(
        ChatMessage.local(rol: 'asistente', contenido: result['respuesta'] ?? ''),
      );
    } on Exception catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      // Revertir el mensaje optimista del usuario
      if (_mensajes.isNotEmpty) _mensajes.removeLast();
    } finally {
      _enviando = false;
      notifyListeners();
    }
  }

  // ── Cargar historial de una sesión existente ─────────────────────────────────
  Future<void> cargarHistorial(String idSesion) async {
    _cargando = true;
    _error    = null;
    notifyListeners();

    try {
      _idSesion = idSesion;
      _mensajes = await _service.obtenerHistorial(idSesion);
    } on Exception catch (_) {
      _mensajes = [];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // ── Iniciar una nueva conversación ───────────────────────────────────────────
  void nuevaConversacion() {
    _mensajes  = [];
    _idSesion  = null;
    _error     = null;
    _enviando  = false;
    notifyListeners();
  }

  // ── Limpiar error tras mostrarlo ────────────────────────────────────────────
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
