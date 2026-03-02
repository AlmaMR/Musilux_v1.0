import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
            const Row(
              children: [
                Expanded(
                  child: CategoryCard(
                    title: 'Instrumentos',
                    subtitle: 'Descubre nuestra colección',
                    imageUrl:
                        'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=600&q=80',
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CategoryCard(
                    title: 'Iluminación',
                    subtitle: 'Soluciones para cada ambiente',
                    imageUrl:
                        'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=600&q=80',
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CategoryCard(
                    title: 'Vinilos',
                    subtitle: 'Sonido Clásico, calidad premium',
                    imageUrl:
                        'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=600&q=80',
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

            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
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
                  title: 'Fender Bajo Eléctrico',
                  price: 7999.99,
                  imageUrl:
                      'https://images.unsplash.com/photo-1550291652-6ea9114a47b1?w=400',
                  tags: const ['Fender', 'Todo Incluido', 'Pack'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
                ProductCard(
                  title: 'Bola de Discoteca Grande',
                  price: 1899.99,
                  imageUrl:
                      'https://images.unsplash.com/photo-1567593810070-7a3d471af022?w=400',
                  tags: const ['Disco', 'Espejos', 'Lataxar'],
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/detalle-producto'),
                ),
              ],
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
