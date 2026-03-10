import 'package:flutter/material.dart';
import 'package:musilux/product.dart'; // Importación necesaria para el uso de la clase Product
import '../widgets/shared_components.dart';
import '../features/catalog/data/api_service.dart';
import '../features/catalog/data/product_model.dart';
import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return BaseLayout( // Asumiendo que BaseLayout maneja su propio scroll o tiene altura fija
      child: SingleChildScrollView( // ¡Solución al problema de scroll!
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BANNER PRINCIPAL
              Container(
                width: double.infinity,
                height: isMobile ? 250 : 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const NetworkImage(
                      'https://images.unsplash.com/photo-1507874251733-c2660a442753?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // URL de imagen más fiable
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tu Música, Tu Estilo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Equípate con lo mejor en Musilux',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/instrumentos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Comprar Ahora',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Categorías
              Row(
                children: [
                  Expanded(
                    child: CategoryCard(
                      title: 'Instrumentos',
                      imageUrl:
                          'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=600&q=80',
                      onTap: () => Navigator.pushNamed(context, '/instrumentos'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CategoryCard(
                      title: 'Iluminación',
                      imageUrl:
                          'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=600&q=80',
                      onTap: () => Navigator.pushNamed(context, '/iluminacion'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CategoryCard(
                      title: 'Vinilos',
                      imageUrl:
                          'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=600&q=80',
                      onTap: () => Navigator.pushNamed(context, '/vinilos'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Promociones
              const Text(
                'Promociones Destacadas!!!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu destino para instrumentos, iluminación y vinilos de calidad.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),

              FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No hay promociones disponibles.');
                  }

                  // Tomamos solo los primeros 3 productos para el Home
                  final products = snapshot.data!.take(3).toList();

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: products.map((productModel) {
                      // Convertimos ProductModel a Product para el ProductCard y la navegación
                      final product = Product(
                        id: productModel.id,
                        name: productModel.name,
                        description: productModel.description,
                        price: productModel.price,
                        imageUrl: productModel.imageUrl,
                        category: productModel.category,
                      );
                      return ProductCard(
                        product: product,
                        isSale: true, // Asumiendo que los productos de promoción están en oferta
                        onDetailsTap: () => Navigator.pushNamed(
                          context,
                          '/detalle-producto',
                          arguments: product, // Pasamos el objeto Product completo
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 50),

              // Banner Demo
              const Text(
                '¿Necesitas una demostración?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Contáctanos para una demostración personalizada de nuestros productos.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: const Text('Solicitar Cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
