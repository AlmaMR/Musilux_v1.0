import 'package:flutter/material.dart';
import 'package:musilux/models/product.dart';
import 'package:musilux/services/api_service.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  final ApiService _apiService = ApiService();

  bool get isMobile => MediaQuery.of(context).size.width < 800;

  @override
  void initState() {
    super.initState();
    // Podríamos tener un endpoint específico para ofertas, pero por ahora traemos todos.
    _productsFuture = _apiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BANNER PRINCIPAL (sin cambios)
          Container(
            width: double.infinity,
            height: isMobile ? 250 : 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage(
                  'https://scontent.ftpq1-1.fna.fbcdn.net/v/t39.30808-6/474271411_1043605514446919_7181129950938001225_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=2a1932&_nc_eui2=AeHXNpbO7QC7jtwJROPcZGDL2sHPTG50jv_awc9MbnSO_9lCsTgey_YkZ14aaaVKwUyFI_i-PeqHPnjyAoNU4VtI&_nc_ohc=O6GYxOj6bpsQ7kNvwEIjJx6&_nc_oc=AdkI3gHI5r7VvaFNOVISjCjqwyqNUQAiPHxg_TrgdNfa5Y3A4hw4O1GBzq6X92XHUYU&_nc_zt=23&_nc_ht=scontent.ftpq1-1.fna&_nc_gid=mLLU6rsm3oFAAqLKgRhnZw&_nc_ss=8&oh=00_AfxDoWsTaTtKpQ23J-29fPH4JESmqM9dl9WMrqcG3MaGiA&oe=69B6293C',
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

          const SizedBox(height: 40),

          // SECCIÓN: CATEGORÍAS (sin cambios)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
            child: const Text(
              'Explora Nuestras Categorías',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
              children: [
                CategoryCard(
                  width: 320,
                  title: 'Instrumentos',
                  subtitle: 'Guitarras, Bajos, Baterías',
                  imageUrl:
                      'https://ortizo.com.co/cdn/shop/articles/INSTRUMENTOS.jpg?v=1736287757&width=1920',
                  onTap: () => Navigator.pushNamed(context, '/instrumentos'),
                ),
                const SizedBox(width: 20),
                CategoryCard(
                  width: 320,
                  title: 'Iluminación',
                  subtitle: 'Soluciones para cada ambiente',
                  imageUrl:
                      'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=600&q=80',
                  onTap: () => Navigator.pushNamed(context, '/iluminacion'),
                ),
                const SizedBox(width: 16),
                CategoryCard(
                  width: 320,
                  title: 'Vinilos',
                  subtitle: 'Tus artistas favoritos',
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJVPVcvu-yGVS4NFvor8Dmz97wDYj3ZETMsA&s',
                  onTap: () => Navigator.pushNamed(context, '/vinilos'),
                ),
              ],
            ),
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

          // SECCIÓN: PROMOCIONES (Refactorizada)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
            child: const Text(
              'Ofertas Especiales 🔥',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 350,
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Muestra un error más descriptivo en la UI.
                  return Center(
                    child: Text(
                      'Error al cargar ofertas: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay ofertas disponibles.'),
                  );
                }

                // Filtramos los productos que están en oferta
                final saleProducts = snapshot.data!
                    .where((p) => p.estaActivo)
                    .toList();

                if (saleProducts.isEmpty) {
                  return const Center(
                    child: Text('No hay ofertas especiales en este momento.'),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
                  itemCount: saleProducts.length,
                  itemBuilder: (context, index) {
                    final product = saleProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ProductCard(
                        isSale: product.estaActivo,
                        title: product.nombre,
                        price: product.precio,
                        tags:
                            const [], // Etiquetas mockeadas temporalmente para compatibilidad del widget visual
                        imageUrl: product.imageUrl,
                        onDetailsTap: () => Navigator.pushNamed(
                          context,
                          '/detalle-producto',
                          arguments: product.id, // Pasamos el ID del producto
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
