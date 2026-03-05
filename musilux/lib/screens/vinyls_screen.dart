import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class VinylsScreen extends StatelessWidget {
  const VinylsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BaseLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la sección y Filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Vinilos',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                if (!isMobile)
                  const Text(
                    'Ordenar por:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Barra de filtros
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Categoría:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildFilterChip('Rock Alternativo'),
                _buildFilterChip('Thrash Metal'),
                _buildFilterChip('K-Pop'),
                _buildFilterChip('Pop'),
                _buildFilterChip('Heavy Metal'),
                if (isMobile) // En celular mostramos el ordenar por debajo
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Ordenar por:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const Divider(height: 40),

            // GRID DE 9 PRODUCTOS CENTRADOS
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 20, // Espacio horizontal
                runSpacing: 30, // Espacio vertical
                alignment: WrapAlignment
                    .center, // ESTO CENTRA LOS PRODUCTOS PERFECTAMENTE
                children: List.generate(9, (index) {
                  // Simulamos diferentes datos para que se vea como tu diseño
                  bool isSale = index == 1 || index == 4 || index == 7;
                  return ProductCard(
                    title: index % 2 == 0
                        ? 'In Utero - Nirvana'
                        : 'Master of Puppets',
                    price: isSale ? 299.99 : 599.99,
                    imageUrl: index % 2 == 0
                        ? 'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=400'
                        : 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400',
                    tags: const ['Analógico', '180g Vinil'],
                    isSale: isSale, // Los que son oferta se pintarán de naranja
                    onDetailsTap: () =>
                        Navigator.pushNamed(context, '/detalle-producto'),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primaryPurple, fontSize: 12),
      ),
    );
  }
}
