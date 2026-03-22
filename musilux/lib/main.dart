import 'package:flutter/material.dart';
import 'package:musilux/screens/contact_screen.dart';
import 'theme/colors.dart';
import 'screens/home_screen.dart';
import 'screens/lighting_screen.dart';
import 'screens/instruments_screen.dart';
import 'screens/vinyls_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_products_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Restaura el token guardado para que el admin no pierda la sesión al recargar
  await AuthService().restoreSession();
  runApp(const MusiluxApp());
}

class MusiluxApp extends StatelessWidget {
  const MusiluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musilux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryPurple,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/instrumentos': (context) => const InstrumentsScreen(),
        '/iluminacion': (context) => const LightingScreen(),
        '/vinilos': (context) => const VinylsScreen(),
        '/contacto': (context) => const ContactScreen(),
        '/perfil': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin-products': (context) => const AdminProductsScreen(),
        // Alias para compatibilidad con navegación existente
        '/admin_products': (context) => const AdminProductsScreen(),
      },
      onGenerateRoute: (settings) {
        // Intercepta la ruta dinámica para inyectar el ID directamente desde la URL
        if (settings.name != null &&
            settings.name!.startsWith('/detalle-producto/')) {
          final productId = settings.name!.replaceFirst(
            '/detalle-producto/',
            '',
          );
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: productId),
            settings:
                settings, // Esto hace que Flutter Web actualice la barra de direcciones
          );
        }
        // Fallback por si alguna pantalla usa la navegación antigua
        if (settings.name == '/detalle-producto') {
          return MaterialPageRoute(
            builder: (context) => const ProductDetailScreen(),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
