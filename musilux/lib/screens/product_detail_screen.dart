import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/shared_components.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Estado para controlar qué vista de prueba mostrar
  String _tipoProducto = 'vinilo'; // 'vinilo', 'instrumento', 'iluminacion'

  // Datos mockeados para cada tipo de producto
  final Map<String, dynamic> _datos = {
    'vinilo': {
      'titulo': 'In Utero - Nirvana',
      'precio': '\$599.99',
      'desc':
          '"In Utero" es una grabación aullante y desafiantemente punk, un retroceso poco sentimental a una era de epifanías de bandas de garaje y rock and roll crudo y sin adornos.',
      'specs': [
        'Producto descontinuado: No',
        'Dimensiones: 31 x 31 cm',
        'ASIN: B00004WP7P',
        'Número de discos: 1',
      ],
      'img':
          'https://images.unsplash.com/photo-1526478806334-5fd488fcaabc?w=600',
    },
    'instrumento': {
      'titulo': 'Fender Stratocaster',
      'precio': '\$4999.99',
      'desc':
          'La Stratocaster es el arquetipo de la guitarra eléctrica. Cuenta con un mástil de arce, cuerpo de aliso y 3 pastillas de bobina simple para un tono cristalino y versátil.',
      'specs': [
        'Cuerpo: Aliso',
        'Mástil: Arce',
        'Trastes: 22 Medium Jumbo',
        'Pastillas: 3x Single-Coil',
      ],
      'img':
          'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=600',
    },
    'iluminacion': {
      'titulo': 'Foco Láser LED RGB',
      'precio': '\$850.00',
      'desc':
          'Foco láser profesional con tecnología LED RGB. Perfecto para escenarios, discotecas y eventos en vivo. Controlable vía DMX o de forma automática rítmica.',
      'specs': [
        'Potencia: 50W',
        'Canales DMX: 7',
        'Modos: Auto, Audio rítmico, DMX',
        'Vida útil LED: 50,000 hrs',
      ],
      'img':
          'https://images.unsplash.com/photo-1533923156502-be31530547c4?w=600',
    },
  };

  @override
  Widget build(BuildContext context) {
    final productoActual = _datos[_tipoProducto]!;

    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PANEL DE VISTA DE PRUEBA
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tagBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryPurple.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.science,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Vista de Prueba:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _TestTab(
                    title: 'Vinilo',
                    isSelected: _tipoProducto == 'vinilo',
                    onTap: () => setState(() => _tipoProducto = 'vinilo'),
                  ),
                  const SizedBox(width: 8),
                  _TestTab(
                    title: 'Instrumentos',
                    isSelected: _tipoProducto == 'instrumento',
                    onTap: () => setState(() => _tipoProducto = 'instrumento'),
                  ),
                  const SizedBox(width: 8),
                  _TestTab(
                    title: 'Iluminación',
                    isSelected: _tipoProducto == 'iluminacion',
                    onTap: () => setState(() => _tipoProducto = 'iluminacion'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // CONTENEDOR PRINCIPAL DEL PRODUCTO
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna Izquierda: Imágenes
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            productoActual['img'],
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back_ios, size: 16),
                            const SizedBox(width: 10),
                            _Thumbnail(productoActual['img']),
                            const SizedBox(width: 10),
                            const _Thumbnail(
                              'https://images.unsplash.com/photo-1619983081563-430f63602796?w=100',
                            ),
                            const SizedBox(width: 10),
                            const _Thumbnail(
                              'https://images.unsplash.com/photo-1484882195048-0d3ee78b87ee?w=100',
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),

                  // Columna Derecha: Info
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productoActual['titulo'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          productoActual['precio'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          productoActual['desc'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Especificaciones Técnicas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Generar especificaciones dinámicas
                        ...List.generate(
                          productoActual['specs'].length,
                          (index) => _SpecItem(productoActual['specs'][index]),
                        ),

                        const SizedBox(height: 30),

                        // DEMOS DINÁMICOS DEPENDIENDO DEL TIPO
                        if (_tipoProducto == 'vinilo') _buildAudioDemo(),
                        if (_tipoProducto == 'instrumento') _buildVideoDemo(),
                        if (_tipoProducto == 'iluminacion')
                          _buildLightingDemo(),

                        const SizedBox(height: 40),

                        // Botones de Compra
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Agregado al carrito'),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 16,
                              ),
                              label: const Text(
                                'Agregar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPurpleHover,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (context) => const CheckoutModal(),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPurpleHover,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Comprar Ahora',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES DE DEMO ---

  Widget _buildAudioDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Demo de Audio',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.skip_previous, size: 30),
            SizedBox(width: 20),
            Icon(Icons.play_arrow, size: 40, color: AppColors.primaryPurple),
            SizedBox(width: 20),
            Icon(Icons.skip_next, size: 30),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('00:00', style: TextStyle(fontSize: 12)),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const Text('01:30', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prueba de Sonido (Video)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=600',
              ),
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
          ),
        ),
      ],
    );
  }

  Widget _buildLightingDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Simulador de Colores DMX',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _ColorCircle(Colors.red),
            const SizedBox(width: 10),
            _ColorCircle(Colors.green),
            const SizedBox(width: 10),
            _ColorCircle(Colors.blue),
            const SizedBox(width: 10),
            _ColorCircle(Colors.purple),
            const SizedBox(width: 10),
            _ColorCircle(Colors.yellow),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Selecciona un color para ver una vista previa.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  const _ColorCircle(this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class _TestTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TestTab({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryPurple,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String url;
  const _Thumbnail(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String text;
  const _SpecItem(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
