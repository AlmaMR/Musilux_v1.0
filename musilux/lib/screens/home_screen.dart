import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

            // Categorías convertidas en Carrusel
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  CategoryCard(
                    width: 320,
                    title: 'Instrumentos',
                    subtitle: 'Descubre nuestra colección',
                    imageUrl:
                        'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=600&q=80',
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
                  const SizedBox(width: 20),
                  CategoryCard(
                    width: 320,
                    title: 'Iluminación',
                    subtitle: 'Soluciones para cada ambiente',
                    imageUrl:
                        'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=600&q=80',
                    onTap: () {
                      // Aquí puedes agregar la navegación a Iluminación en el futuro
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navegando a Iluminación...'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  CategoryCard(
                    width: 320,
                    title: 'Vinilos',
                    subtitle: 'Sonido Clásico, calidad premium',
                    imageUrl:
                        'https://images.unsplash.com/photo-1526478806334-5fd488fcaabc?w=600&q=80', // Enlace de imagen más estable
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/vinilos',
                    ), // Redirección a la pantalla Vinilos
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
              'Aprovecha nuestras ofertas por tiempo limitado.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),

            // Carrusel de Promociones (Responsivo)
            SizedBox(
              height: 420,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
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
                  const SizedBox(width: 20),
                  ProductCard(
                    title: 'Fender Bajo Eléctrico',
                    price: 7999.99,
                    imageUrl:
                        'https://images.unsplash.com/photo-1550291652-6ea9114a47b1?w=400',
                    tags: const ['Fender', 'Todo Incluido', 'Pack'],
                    onDetailsTap: () =>
                        Navigator.pushNamed(context, '/detalle-producto'),
                  ),
                  const SizedBox(width: 20),
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
