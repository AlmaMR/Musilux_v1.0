import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../features/catalog/data/api_service.dart';
import '../features/catalog/data/product_model.dart';

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
    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección Bienvenido
            const Text(
              'Bienvenido!!!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu destino para instrumentos, iluminación y vinilos de calidad.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),

            // Categorías
            Row(
              children: [
                Expanded(
                  child: CategoryCard(
                    title: 'Instrumentos',
                    subtitle: 'Descubre nuestra colección',
                    imageUrl:
                        'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=600&q=80',
                    onTap: () => Navigator.pushNamed(context, '/instrumentos'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CategoryCard(
                    title: 'Iluminación',
                    subtitle: 'Soluciones para cada ambiente',
                    imageUrl:
                        'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=600&q=80',
                    onTap: () => Navigator.pushNamed(context, '/iluminacion'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CategoryCard(
                    title: 'Vinilos',
                    subtitle: 'Sonido Clásico, calidad premium',
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
                  children: products.map((product) {
                    return ProductCard(
                      title: product.nombre,
                      price: product.precio,
                      imageUrl:
                          'https://images.unsplash.com/photo-1550291652-6ea9114a47b1?w=400', // Placeholder
                      tags: [product.tipoProducto],
                      onDetailsTap: () => Navigator.pushNamed(
                        context,
                        '/detalle-producto',
                        arguments: product,
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
              'Contactanos para una demostracion personalidades de nuestros productos.',
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
          ],
        ),
      ),
    );
  }
}
