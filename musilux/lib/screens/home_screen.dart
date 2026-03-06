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
                      'https://ortizo.com.co/cdn/shop/articles/INSTRUMENTOS.jpg?v=1736287757&width=1920',
                  onTap: () => Navigator.pushNamed(context, '/instrumentos'),
                ),
                const SizedBox(width: 16),
                CategoryCard(
                  width: 320,
                  title: 'Iluminación',
                  subtitle: 'Luces, Láser, Humo',
                  imageUrl:
                      'https://m.media-amazon.com/images/I/81xXM5UvMhL._AC_UF350,350_QL80_.jpg',
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
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlJUWXrueZ5TbCCOf0m3_CCQW2OVwsiHjR0g&s',
                  onTap: () => Navigator.pushNamed(context, '/instrumentos'),
                ),
                const SizedBox(width: 16),
                CategoryCard(
                  width: 320,
                  title: 'Iluminación',
                  subtitle: 'Luces, Láser, Humo',
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg2Q254ZdlDEK0mCiDff8ODejXJzMC0SQf0Q&s',
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
                      'https://m.media-amazon.com/images/S/aplus-media-library-service-media/e04da6f5-c8dd-43a8-b82a-ef27cb61cec2.__CR0,0,600,600_PT0_SX300_V1___.png',
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
                      'https://m.media-amazon.com/images/I/81O80Pn0ZsL._AC_UF1000,1000_QL80_.jpg',
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
                      'https://m.media-amazon.com/images/I/7115TB+TXeL.jpg',
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
                      'https://m.media-amazon.com/images/I/81oDljdj-FL._UF1000,1000_QL80_.jpg',
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
                      'https://m.media-amazon.com/images/I/51Pm9zO5QIL._AC_UF350,350_QL80_.jpg',
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
