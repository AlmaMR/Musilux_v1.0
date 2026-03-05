import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../theme/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isPlaying = false;
  double audioProgress = 0.3; // Simulando el progreso de la canción al 30%

  @override
  Widget build(BuildContext context) {
    // Detectamos si es pantalla pequeña (celular)
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BaseLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: 40,
        ),
        child: isMobile
            // Si es celular, apilamos hacia abajo (Columna)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(isMobile),
                  const SizedBox(height: 30),
                  _buildDetails(),
                ],
              )
            // Si es web/tablet grande, ponemos imagen y detalles lado a lado (Fila)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildImage(isMobile)),
                  const SizedBox(width: 50),
                  Expanded(child: _buildDetails()),
                ],
              ),
      ),
    );
  }

  // ==========================================
  // WIDGET: IMAGEN DEL PRODUCTO
  // ==========================================
  Widget _buildImage(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=800', // Imagen de ejemplo (Vinilo Nirvana)
          fit: BoxFit.cover,
          width: double.infinity,
          height: isMobile ? 350 : 500,
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET: DETALLES, PRECIO, REPRODUCTOR Y BOTÓN
  // ==========================================
  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sliver',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Nirvana',
          style: TextStyle(fontSize: 22, color: Colors.black54),
        ),
        const SizedBox(height: 16),

        // Etiquetas (Tags)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Analógico', '1994', '180g Vinil']
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tagBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: AppColors.tagText,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),

        // Precio (Usando el color naranja de ofertas que configuramos antes)
        const Text(
          '\$299.99',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.priceSale,
          ),
        ),
        const SizedBox(height: 24),

        // Descripción
        const Text(
          'Sliver es una canción de la banda de grunge estadounidense Nirvana. Un clásico indiscutible en formato vinilo de 180 gramos para la mejor fidelidad de audio. Ideal para coleccionistas.',
          style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
        ),
        const SizedBox(height: 30),

        // REPRODUCTOR DE AUDIO
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.audiotrack,
                    size: 18,
                    color: AppColors.primaryPurple,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Vista previa del audio',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Botón Play/Pause
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: AppColors.primaryPurple,
                      size: 48,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Barra de progreso
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14.0,
                        ),
                      ),
                      child: Slider(
                        value: audioProgress,
                        activeColor: AppColors.primaryPurple,
                        inactiveColor: Colors.grey.shade300,
                        onChanged: (val) {
                          setState(() {
                            audioProgress = val;
                          });
                        },
                      ),
                    ),
                  ),
                  // Tiempo
                  const Text(
                    '1:14 / 3:45',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Botón "Agregar al Carrito"
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Muestra un mensaje y abre el carrito automáticamente
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sliver agregado al carrito 🛒'),
                  backgroundColor: AppColors.primaryPurple,
                ),
              );
              Scaffold.of(
                context,
              ).openEndDrawer(); // Abre el panel lateral derecho (EndDrawer)
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: const Text(
              'Agregar al Carrito',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurpleHover,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
