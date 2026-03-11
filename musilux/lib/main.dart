import 'package:flutter/material.dart';
import 'package:musilux/screens/contact_screen.dart';
import 'theme/colors.dart'; // Asegúrate de tener este archivo
import 'screens/home_screen.dart';
import 'screens/lighting_screen.dart';
import 'screens/instruments_screen.dart';
import 'screens/vinyls_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'services/admin_products_screen.dart'; // Importar nueva pantalla

void main() {
  runApp(const MusiluxApp());
}

class MusiluxApp extends StatelessWidget {
  const MusiluxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musilux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryPurple,
        fontFamily: 'Roboto', // O la fuente que estés usando
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/instrumentos': (context) => const InstrumentsScreen(),
        '/iluminacion': (context) => const LightingScreen(),
        '/vinilos': (context) => const VinylsScreen(),
        '/contacto': (context) => const ContactScreen(),
        '/detalle-producto': (context) => const ProductDetailScreen(),
        '/perfil': (context) => const ProfileScreen(),
        '/admin_products': (context) =>
            const AdminProductsScreen(), // Registrar ruta
      },
    );
  }
}
