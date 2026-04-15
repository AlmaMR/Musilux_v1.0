import 'package:flutter/foundation.dart';

class ApiConstants {
  /// IP de la máquina de desarrollo en la red local.
  /// Cámbiala si tu IP cambia (ver con `ipconfig` en Windows).
  static const String _devIp = '10.11.5.71';
  static const int _devPort = 8080;

  static String get baseUrl {
    if (kIsWeb) {
      // Web corre en el mismo host, localhost funciona
      return 'http://localhost:$_devPort/api';
    }
    // Dispositivo físico Y emulador usan la IP real de la PC
    return 'http://$_devIp:$_devPort/api';
  }

  static const String productsEndpoint = '/products';
  static const String chatEndpoint = '/chat';
  static const String chatHistoryEndpoint = '/chat/history';
}
