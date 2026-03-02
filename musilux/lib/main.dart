import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'screens/home_screen.dart';
import 'screens/vinyls_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/instruments_screen.dart';
import 'screens/lighting_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MusiluxApp());
}

// ==========================================
// APLICACIÓN PRINCIPAL & RUTAS
// ==========================================
class MusiluxApp extends StatelessWidget {
  const MusiluxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musilux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryPurple,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // Definición de las rutas importadas de la carpeta screens/
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/vinilos': (context) => const VinylsScreen(),
        '/detalle-producto': (context) => const ProductDetailScreen(),
        '/instrumentos': (context) => const InstrumentsScreen(),
        '/iluminacion': (context) => const LightingScreen(),
        '/contacto': (context) => const ContactScreen(),
        '/buscar': (context) => const SearchScreen(),
        '/perfil': (context) => const ProfileScreen(),
      },
    );
  }
}
