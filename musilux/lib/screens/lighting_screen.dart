import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';

class LightingScreen extends StatelessWidget {
  const LightingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return BaseLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 40,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Iluminación Profesional',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Los mejores equipos de luces para escenarios, discotecas y estudios.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                ProductCard(
                  title: 'Bola de Discoteca Grande',
                  price: 1899.99,
                  imageUrl:
                      'https://images.unsplash.com/photo-1567593810070-7a3d471af022?w=400',
                  tags: const ['Disco', 'Fiesta', 'Clásico'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
                ProductCard(
                  title: 'Foco Láser LED RGB',
                  price: 850.00,
                  imageUrl:
                      'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=400',
                  tags: const ['LED', 'Multicolor', 'DMX'],
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
