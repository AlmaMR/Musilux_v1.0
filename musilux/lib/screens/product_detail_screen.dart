import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BaseLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: 30,
        ),
        child: isMobile
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageSection(),
        const SizedBox(height: 20),
        _buildInfoSection(context),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildImageSection()),
        const SizedBox(width: 40),
        Expanded(flex: 4, child: _buildInfoSection(context)),
      ],
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        '[https://images.unsplash.com/photo-1519892300165-cb5542fb47c7?w=1200](https://images.unsplash.com/photo-1519892300165-cb5542fb47c7?w=1200)',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 400,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Batería Acústica Yamaha',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          '\$15,499.00',
          style: TextStyle(
            fontSize: 28,
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Batería acústica profesional de 5 piezas ideal para estudios y presentaciones en vivo. '
          'Incluye platillos, herrajes de alta resistencia y un sonido espectacular garantizado por Yamaha.',
          style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
        ),
        const SizedBox(height: 30),

        // Botones de Acción (El agregado que pediste)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Iniciando proceso de compra...'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .orange
                    .shade800, // Color llamativo para comprar ahora
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Comprar Ahora',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Agregado al carrito de compras'),
                  ),
                );
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: AppColors.primaryPurple,
              ),
              label: const Text(
                'Agregar al Carrito',
                style: TextStyle(color: AppColors.primaryPurple, fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: const BorderSide(
                  color: AppColors.primaryPurple,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
