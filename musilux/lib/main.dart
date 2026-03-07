import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'screens/home_screen.dart';
import 'screens/vinyls_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/admin_products_screen.dart';

void main() {
  runApp(const MusiluxApp());
}

// ==========================================
// APLICACIÓN PRINCIPAL & RUTAS
// ==========================================
class MusiluxApp extends StatelessWidget {
  const MusiluxApp({super.key});

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
        '/admin': (context) => const AdminProductsScreen(),
      },
    );
  }
}
