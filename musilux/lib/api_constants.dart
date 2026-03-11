import 'package:flutter/foundation.dart';

class ApiConstants {
  // Detecta automáticamente si estás en Android (Emulador) o en Windows
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }
    // Para Android Emulator usamos 10.0.2.2, para otros (iOS/Windows) localhost
    return 'http://10.0.2.2:8000/api';
  }

  static const String productsEndpoint = '/products';
}
