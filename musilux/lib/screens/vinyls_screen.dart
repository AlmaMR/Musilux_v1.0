import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../features/catalog/data/api_service.dart';
import '../features/catalog/data/product_model.dart';

class VinylsScreen extends StatefulWidget {
  const VinylsScreen({super.key});

  @override
  State<VinylsScreen> createState() => _VinylsScreenState();
}

class _VinylsScreenState extends State<VinylsScreen> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vinilos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text(
                      'Ordenar por: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Precio Ascendente',
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(Icons.arrow_drop_down, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  'Categoría: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                _FilterTag('Rock Alternativo'),
                _FilterTag('Thrash Metal'),
                _FilterTag('K-Pop'),
                _FilterTag('Pop'),
                _FilterTag('Heavy Metal'),
              ],
            ),
            const SizedBox(height: 30),

            // Grid de Productos
            FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron productos.'),
                  );
                }

                final products = snapshot.data!;

                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: products.map((product) {
                    return ProductCard(
                      title: product.nombre,
                      price: product.precio,
                      // Usamos una imagen genérica ya que el backend aún no envía imágenes
                      imageUrl:
                          'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=400',
                      tags: [
                        product.tipoProducto,
                        if (product.estaActivo) 'Disponible' else 'Agotado',
                      ],
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
          ],
        ),
      ),
    );
  }
}

class _FilterTag extends StatelessWidget {
  final String text;
  const _FilterTag(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}
