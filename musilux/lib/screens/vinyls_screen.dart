import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';

class VinylsScreen extends StatelessWidget {
  const VinylsScreen({Key? key}) : super(key: key);

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
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                ProductCard(
                  title: 'In Utero',
                  price: 599.99,
                  imageUrl:
                      'https://images.unsplash.com/photo-1526478806334-5fd488fcaabc?w=400',
                  tags: const ['Analogico', '1993', '180g Vinil'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
                ProductCard(
                  title: 'Sliver',
                  price: 299.99,
                  imageUrl:
                      'https://images.unsplash.com/photo-1619983081563-430f63602796?w=400',
                  tags: const ['Analogico', '1994', '180g Vinil'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
                ProductCard(
                  title: 'Incesticide 20 Anniversary',
                  price: 1999.99,
                  imageUrl:
                      'https://images.unsplash.com/photo-1484882195048-0d3ee78b87ee?w=400',
                  tags: const ['Analogico', '1992', '180g Vinil'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTag extends StatelessWidget {
  final String text;
  const _FilterTag(this.text, {Key? key}) : super(key: key);

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
