import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class InstrumentsScreen extends StatelessWidget {
  const InstrumentsScreen({Key? key}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Instrumentos',
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
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Categoría:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildFilterChip('Guitarras'),
                _buildFilterChip('Bajos'),
                _buildFilterChip('Baterías'),
                _buildFilterChip('Teclados'),
              ],
            ),
            const Divider(height: 40),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 20,
                runSpacing: 30,
                alignment: WrapAlignment.center, // Centrado perfecto
                children: List.generate(9, (index) {
                  return ProductCard(
                    title: 'Fender Stratocaster ${index + 1}',
                    price: 4999.99,
                    imageUrl:
                        'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=400',
                    tags: const ['Fender', 'Eléctrica'],
                    isSale: false,
                    onDetailsTap: () {},
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
