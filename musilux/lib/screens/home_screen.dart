import 'package:flutter/material.dart';
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
    return BaseLayout(
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
                    'https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/485421080_1090799343060869_8054663387557638822_n.jpg?stp=cp6_dst-jpg_tt6&_nc_cat=110&ccb=1-7&_nc_sid=7b2446&_nc_ohc=5tu6MwW-JMgQ7kNvwHIPcSu&_nc_oc=Adk1glrbuPw9NLMwTsbyZdmbku8NrpmPY5ReBPZKHBu3FjjMAImLaHtLYAyNzFTOjDw&_nc_zt=23&_nc_ht=scontent.fgdl9-1.fna&_nc_gid=9QXx4Agu7CIfeQ8Vx_xTEg&_nc_ss=8&oh=00_AfxjQA8Ab-Rkis26mL-B0T7iTjckAOa3uIA59fzg--ZllQ&oe=69AFB2D9',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
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
