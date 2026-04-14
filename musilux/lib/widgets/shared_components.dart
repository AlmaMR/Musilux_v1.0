import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../providers/auth_provider.dart';
import '../core/app_router.dart';

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
              route: '/instrumentos',
              onTap: () => Navigator.pushNamed(context, '/instrumentos'),
            ),
            _NavBarItem(
              title: 'Iluminación',
              route: '/iluminacion',
              onTap: () => Navigator.pushNamed(context, '/iluminacion'),
            ),
            _NavBarItem(
              title: 'Vinilos',
              route: '/vinilos',
              onTap: () => Navigator.pushNamed(context, '/vinilos'),
            ),
            _NavBarItem(
              title: 'Contacto',
              route: '/contacto',
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

          // --- BOTÓN ADMIN INTELIGENTE (visible solo para roles admin) ---
          const _AdminMenuButton(),

          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white70),
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTÓN ADMIN INTELIGENTE
// Visible solo para roles administrativos. Superadmin ve un menú con todas las
// secciones; cada admin específico va directo a su dashboard.
// ─────────────────────────────────────────────────────────────────────────────
class _AdminMenuButton extends StatelessWidget {
  const _AdminMenuButton();

  // Etiqueta legible por rol
  static String _labelRol(String rol) {
    switch (rol) {
      case 'admin_pedidos':    return 'Gestión de Pedidos';
      case 'admin_usuarios':   return 'Gestión de Usuarios';
      case 'admin_inventario': return 'Inventario';
      case 'admin_ventas':     return 'Ventas';
      case 'admin_soporte':    return 'Soporte';
      default:                 return 'Panel Admin';
    }
  }

  // Icono por sección
  static IconData _iconRol(String rol) {
    switch (rol) {
      case 'admin_pedidos':    return Icons.receipt_long_outlined;
      case 'admin_usuarios':   return Icons.people_outline;
      case 'admin_inventario': return Icons.inventory_2_outlined;
      case 'admin_ventas':     return Icons.bar_chart_outlined;
      case 'admin_soporte':    return Icons.support_agent_outlined;
      default:                 return Icons.admin_panel_settings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Sin sesión o rol no-admin → oculto
    if (!auth.estaAutenticado) return const SizedBox.shrink();
    if (auth.esCliente || auth.rolActual == 'visitante') {
      return const SizedBox.shrink();
    }

    // ── Superadmin: menú desplegable con TODAS las secciones ──────────────
    if (auth.esSuperAdmin) {
      return PopupMenuButton<String>(
        tooltip: 'Panel de Administración',
        onSelected: (ruta) => Navigator.pushNamed(context, ruta),
        offset: const Offset(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Stack(
          alignment: Alignment.topRight,
          children: [
            const Icon(Icons.admin_panel_settings, color: AppColors.primaryPurple),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        itemBuilder: (_) => [
          // Cabecera informativa (no navegable)
          PopupMenuItem(
            enabled: false,
            height: 36,
            child: Text(
              'SUPER ADMIN — Acceso total',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryPurple,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const PopupMenuDivider(),
          _menuItem(AppRoutes.superAdminDashboard,
              Icons.dashboard_outlined, 'Dashboard principal'),
          _menuItem(AppRoutes.pedidosDashboard,
              Icons.receipt_long_outlined, 'Gestión de Pedidos'),
          _menuItem(AppRoutes.usuariosDashboard,
              Icons.people_outline, 'Gestión de Usuarios'),
          _menuItem(AppRoutes.inventarioDashboard,
              Icons.inventory_2_outlined, 'Inventario / Productos'),
          _menuItem(AppRoutes.ventasDashboard,
              Icons.bar_chart_outlined, 'Ventas'),
          _menuItem(AppRoutes.soporteDashboard,
              Icons.support_agent_outlined, 'Soporte'),
        ],
      );
    }

    // ── Admin específico: botón directo a su dashboard ────────────────────
    final ruta  = AppRouter.homeSegunRol(auth.rolActual);
    final label = _labelRol(auth.rolActual);
    final icono = _iconRol(auth.rolActual);

    return IconButton(
      icon: Icon(icono, color: Colors.white70),
      tooltip: label,
      onPressed: () => Navigator.pushNamed(context, ruta),
    );
  }

  /// Construye un ítem de menú con icono y texto.
  static PopupMenuItem<String> _menuItem(
      String ruta, IconData icono, String label) {
    return PopupMenuItem<String>(
      value: ruta,
      child: Row(
        children: [
          Icon(icono, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final String? route;

  const _NavBarItem({required this.title, required this.onTap, this.route});

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final isActive = widget.route != null && currentRoute == widget.route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive || _hovered
                      ? AppColors.primaryPurple
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                color: isActive ? AppColors.primaryPurple : (_hovered ? Colors.white : Colors.white70),
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
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
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (c, u, e) => Container(color: Colors.grey),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onDetailsTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Imagen con badge de oferta ──
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textDisabled,
                        size: 36,
                      ),
                    ),
                  ),
                  if (isSale)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.priceSale,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'OFERTA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Información del producto ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tags
                          .take(2)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.tagBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: AppColors.tagText,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  if (tags.isNotEmpty) const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Agregado al carrito')),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          minimumSize: const Size(36, 36),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.add_shopping_cart, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
