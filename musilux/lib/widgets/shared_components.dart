import 'package:flutter/material.dart';
import '../theme/colors.dart';

// ==========================================
// LAYOUT BASE (Header, Footer, Drawers)
// ==========================================
class BaseLayout extends StatelessWidget {
  final Widget child;
  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const NavDrawer(),
      endDrawer: const CartDrawer(),
      body: Column(
        children: [
          const CustomHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [child, const CustomFooter()]),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ENCABEZADO (Header y Barra de Navegación)
// ==========================================
class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      height: 70,
      color: AppColors.headerBg,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/') {
                  Navigator.pushNamed(context, '/');
                }
              },
              child: const Text(
                'Musilux',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _NavBarItem(
              title: 'Instrumentos',
              onTap: () => Navigator.pushNamed(context, '/instrumentos'),
            ),
            _NavBarItem(
              title: 'Iluminación',
              onTap: () => Navigator.pushNamed(context, '/iluminacion'),
            ),
            _NavBarItem(
              title: 'Vinilos',
              onTap: () => Navigator.pushNamed(context, '/vinilos'),
            ),
            _NavBarItem(
              title: 'Contacto',
              onTap: () => Navigator.pushNamed(context, '/contacto'),
            ),
            const SizedBox(width: 20),
          ],

          // --- BOTÓN DE BUSCADOR FUNCIONAL ---
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white70),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),

          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white70,
            ),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white70),
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavBarItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// PIE DE PÁGINA (Footer)
// ==========================================
class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: const Column(
        children: [
          Text(
            'Contacto: info@musilux.com | Tel: 311 123 8040',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          SizedBox(height: 8),
          Text(
            'Enlaces Útiles: Términos y Condiciones | Política de Privacidad',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// MENÚ DE NAVEGACIÓN MÓVIL (Drawer Izquierdo)
// ==========================================
class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.headerBg),
            child: Center(
              child: Text(
                'Musilux',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Instrumentos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/instrumentos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: const Text('Iluminación'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/iluminacion');
            },
          ),
          ListTile(
            leading: const Icon(Icons.album),
            title: const Text('Vinilos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/vinilos');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/perfil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Contacto'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contacto');
            },
          ),
        ],
      ),
    );
  }
}

// ==========================================
// CARRITO DE COMPRAS (Drawer Derecho)
// ==========================================
class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade100,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              'Carrito de compras',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Carrito vacío',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TARJETA DE CATEGORÍA
// ==========================================
class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  final double? width;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 300,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.grey),
            ),
            Container(color: Colors.black.withValues(alpha: 0.4)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TARJETA DE PRODUCTO
// ==========================================
class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final List<String> tags;
  final VoidCallback onDetailsTap;
  final bool isSale;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.tags,
    required this.onDetailsTap,
    this.isSale = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSale
                        ? Colors.orange.shade800
                        : AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Agregado al carrito'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Agregar',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/detalle-producto');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: const BorderSide(
                            color: AppColors.primaryPurple,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Detalles',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// DELEGADO DEL BUSCADOR (SearchDelegate)
// ==========================================
class ProductSearchDelegate extends SearchDelegate<String> {
  // Simulación de productos en la tienda
  final List<String> products = [
    'Batería Acústica Yamaha',
    'Controlador DJ Pioneer',
    'Guitarra Acústica Taylor',
    'Sliver - Nirvana (Vinilo)',
    'Teclado Korg 61 Teclas',
    'Cabeza Móvil Beam 230W',
    'Láser RGB Animación',
    'Máquina de Humo 1500W',
    'Barra LED Ultravioleta UV',
    'Par LED 54x3W RGBW',
    'Controlador DMX 512',
    'Luz Estroboscópica 1000W',
  ];

  @override
  String get searchFieldLabel => 'Buscar en Musilux...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) => p.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron resultados para "$query"',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.music_note, color: AppColors.primaryPurple),
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
            Navigator.pushNamed(context, '/producto_detalle');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? ['Guitarra', 'Luces LED', 'Vinilos Rock']
        : products
              .where((p) => p.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
