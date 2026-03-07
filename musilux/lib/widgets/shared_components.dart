import 'package:flutter/material.dart';
import '../theme/colors.dart';

// ==========================================
// LAYOUT BASE (Header, Footer, Drawer)
// ==========================================
class BaseLayout extends StatelessWidget {
  final Widget child;
  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: AppColors.headerBg,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          // Logo
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text(
                'Musilux',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Links de Navegación
          _NavBarItem(title: 'Instrumentos', onTap: () {}),
          _NavBarItem(title: 'Iluminación', onTap: () {}),
          _NavBarItem(
            title: 'Vinilos',
            onTap: () => Navigator.pushNamed(context, '/vinilos'),
          ),
          _NavBarItem(title: 'Contacto', onTap: () {}),
          const SizedBox(width: 20),
          // Iconos
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white70,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white70),
            onPressed: () {},
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }
}

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Text(
            'Contacto: info@musilux.com | Tel: 311 123 8040',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          SizedBox(height: 4),
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
// TARJETAS DE PRODUCTO Y CATEGORÍA
// ==========================================

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
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
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final List<String> tags;
  final VoidCallback onDetailsTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.tags,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Tags
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.tagBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryPurple.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.priceText,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text(
                        'Agregar',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: onDetailsTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryPurple,
                        side: const BorderSide(color: AppColors.primaryPurple),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Ver Detalles',
                        style: TextStyle(fontSize: 12),
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
// CARRITO DE COMPRAS Y CHECKOUT
// ==========================================

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 350,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carrito de compras',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                CloseButton(),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: const [
                  _CartItemMock(),
                  _CartItemMock(),
                  _CartItemMock(),
                ],
              ),
            ),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: TextStyle(color: Colors.black54)),
                Text(
                  '\$5997.00',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Envio', style: TextStyle(color: Colors.black54)),
                Text(
                  'Gratis',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$5997.00',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el Drawer
                  showDialog(
                    context: context,
                    builder: (_) => const CheckoutModal(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Finalizar compra',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemMock extends StatelessWidget {
  const _CartItemMock();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1550291652-6ea9114a47b1?w=150',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guitarra eléctrica popular para principiantes',
                  style: TextStyle(fontSize: 12),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('-'),
                            ),
                          ),
                          const Text('1'),
                          InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('+'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '\$1999.00',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.delete_outline, color: Colors.red, size: 20),
        ],
      ),
    );
  }
}

class CheckoutModal extends StatefulWidget {
  const CheckoutModal({super.key});

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Paso $_currentStep de 2',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Completar Compra',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            if (_currentStep == 1) ...[
              _buildTextField(
                'Calle y numero exterior o interior',
                'Calle y numero',
              ),
              _buildTextField('Estado', 'Estado'),
              _buildTextField('Municipio', 'Nayarit'),
              _buildTextField('Codigo Postal', 'Codigo Postal'),
              _buildTextField('Colonia', 'Colonia'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _currentStep = 2),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continuar'),
                ),
              ),
            ] else ...[
              _buildTextField('Numero de Tarjeta', 'xxxx-xxxx-xxxx-xxxx'),
              _buildTextField('Nombre del Titular', 'nombre completo'),
              _buildTextField('Fecha de Vencimiento', '4 digitos'),
              _buildTextField('Codigo de Seguridad', '3 digitos'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Compra realizada con éxito!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Pagar Ahora'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.primaryPurple.withValues(alpha: 0.5),
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primaryPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
