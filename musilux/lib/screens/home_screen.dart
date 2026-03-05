import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BaseLayout(
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
                  '[https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=1600](https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=1600)',
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

          const SizedBox(height: 40),

          // SECCIÓN: CATEGORÍAS (Carrusel Continuo Duplicado)
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
                // Set original
                CategoryCard(
                  width: 320,
                  title: 'Instrumentos',
                  subtitle: 'Guitarras, Bajos, Baterías',
                  imageUrl:
                      '[https://images.unsplash.com/photo-1514807498305-6453f61530e2?w=600](https://images.unsplash.com/photo-1514807498305-6453f61530e2?w=600)',
                  onTap: () => Navigator.pushNamed(context, '/instrumentos'),
                ),
                const SizedBox(width: 16),
                CategoryCard(
                  width: 320,
                  title: 'Iluminación',
                  subtitle: 'Luces, Láser, Humo',
                  imageUrl:
                      '[https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600](https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600)',
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
                const SizedBox(width: 16),
                // Set Duplicado para rellenar pantalla de PC y hacer efecto carrusel
                CategoryCard(
                  width: 320,
                  title: 'Instrumentos',
                  subtitle: 'Guitarras, Bajos, Baterías',
                  imageUrl:
                      '[https://images.unsplash.com/photo-1514807498305-6453f61530e2?w=600](https://images.unsplash.com/photo-1514807498305-6453f61530e2?w=600)',
                  onTap: () => Navigator.pushNamed(context, '/instrumentos'),
                ),
                const SizedBox(width: 16),
                CategoryCard(
                  width: 320,
                  title: 'Iluminación',
                  subtitle: 'Luces, Láser, Humo',
                  imageUrl:
                      '[https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600](https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600)',
                  onTap: () => Navigator.pushNamed(context, '/iluminacion'),
                ),
                const SizedBox(width: 16),
                CategoryCard(
                  width: 320,
                  title: 'Vinilos',
                  subtitle: 'Tus artistas favoritos',
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJ2Pf-McB32UKwDN-cfrFIcs9yt63zAO7fYA&s',
                  onTap: () => Navigator.pushNamed(context, '/vinilos'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // SECCIÓN: PROMOCIONES (Altura corregida para que las tarjetas se vean hermosas)
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

          // Contenedor a 350 de altura. Ahora ProductCard se adaptará perfecto.
          SizedBox(
            height: 350,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
              children: [
                ProductCard(
                  isSale: true,
                  title: 'Batería Acústica Yamaha',
                  price: 15499.00,
                  tags: ['Baterías', 'Oferta'],
                  imageUrl:
                      '[https://images.unsplash.com/photo-1519892300165-cb5542fb47c7?w=600](https://images.unsplash.com/photo-1519892300165-cb5542fb47c7?w=600)',
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/producto/bateria'),
                ),
                const SizedBox(width: 20),
                ProductCard(
                  isSale: true,
                  title: 'Controlador DJ Pioneer',
                  price: 6200.00,
                  tags: ['Audio', 'DJ'],
                  imageUrl:
                      '[https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?w=600](https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?w=600)',
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/producto/dj'),
                ),
                const SizedBox(width: 20),
                ProductCard(
                  isSale: true,
                  title: 'Guitarra Acústica Taylor',
                  price: 9500.00,
                  tags: ['Guitarras', 'Acústica'],
                  imageUrl:
                      '[https://images.unsplash.com/photo-1550985543-f47f38aeea53?w=600](https://images.unsplash.com/photo-1550985543-f47f38aeea53?w=600)',
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/producto/taylor'),
                ),
                const SizedBox(width: 20),
                ProductCard(
                  isSale: true,
                  title: 'Sliver - Nirvana (Vinilo)',
                  price: 299.99,
                  tags: ['Vinilo', 'Rock'],
                  imageUrl:
                      '[https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=600](https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=600)',
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/producto/sliver'),
                ),
                const SizedBox(width: 20),
                ProductCard(
                  isSale: true,
                  title: 'Teclado Korg 61 Teclas',
                  price: 8200.00,
                  tags: ['Teclados', 'Oferta'],
                  imageUrl:
                      '[https://images.unsplash.com/photo-1552422535-c45813c61732?w=600](https://images.unsplash.com/photo-1552422535-c45813c61732?w=600)',
                  onDetailsTap: () =>
                      Navigator.pushNamed(context, '/producto/teclado'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
