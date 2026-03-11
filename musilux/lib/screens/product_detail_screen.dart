import 'package:flutter/material.dart';
import 'package:musilux/models/product.dart';
import 'package:musilux/services/api_service.dart';
import '../theme/colors.dart';
import '../widgets/shared_components.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productFuture;
  final ApiService _apiService = ApiService();
  String? _productId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extraemos el ID del producto de los argumentos de la ruta.
    // Lo hacemos aquí porque ModalRoute.of(context) no está disponible en initState.
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    
    // Si el ID cambia (o es la primera vez), iniciamos una nueva carga.
    if (productId != null && productId != _productId) {
      setState(() {
        _productId = productId;
        _productFuture = _apiService.fetchProductById(_productId!);
      });
    } else if (_productId == null) {
      // Manejo de caso donde no se pasa ID
      setState(() {
        _productFuture = Future.error('No se proporcionó un ID de producto.');
      });
    }
  }
  // Estado para controlar qué vista de prueba mostrar
  String _tipoProducto = 'vinilo'; // 'vinilo', 'instrumento', 'iluminacion'

  // Datos mockeados para cada tipo de producto
  final Map<String, dynamic> _datos = {
    'vinilo': {
      'titulo': 'Unplugged in New York - Nirvana',
      'precio': '\$999.99',
      'desc':
          'El vinilo de Nirvana - MTV Unplugged in New York es una grabación histórica en vivo de noviembre de 1993, lanzada póstumamente en 1994, que destaca por su formato acústico e íntimo.',
      'specs': [
        'Producto descontinuado: No',
        'Dimensiones: 31 x 31 cm',
        'ASIN: B00004WP7P',
        'Número de discos: 1',
      ],
      'img':
          'https://m.media-amazon.com/images/I/61kVo9GKvjL._AC_SX342_SY445_QL70_ML2_.jpg',
    },
    'instrumento': {
      'titulo': 'Guitarra Eléctrica Fender',
      'precio': '\$18500.00',
      'desc':
          'La Fender Kurt Cobain Jag-Stang es una guitarra eléctrica signature diseñada por el líder de Nirvana, lanzada originalmente en los 90, que fusiona características de los modelos Jaguar y Mustang. Destaca por su cuerpo de aliso, escala corta de 24 pulgadas, mástil de arce con diapasón de palisandro y una configuración de pastillas versátil (Humbucker en puente, Single-Coil en mástil) ideal para el sonido grunge.',
      'specs': [
        'Cuerpo: Aliso',
        'Mástil: Arce',
        'Trastes: 22 Medium Jumbo',
        'Pastillas: 3x Single-Coil',
      ],
      'img': 'https://m.media-amazon.com/images/I/61aAV9OZz8L._AC_SY879_.jpg',
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
          'https://m.media-amazon.com/images/I/81u4qN9tV5L._AC_UF1000,1000_QL80_.jpg',
    },
  };

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.primaryPurple.withValues(alpha: 0.3),
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
                    color: Colors.black.withValues(alpha: 0.05),
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
                              'https://m.media-amazon.com/images/I/61kVo9GKvjL._AC_SX342_SY445_QL70_ML2_.jpg',
                            ),
                            const SizedBox(width: 10),
                            const _Thumbnail(
                              'https://m.media-amazon.com/images/I/61kVo9GKvjL._AC_SX342_SY445_QL70_ML2_.jpg',
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // El precio viene como double, lo formateamos.
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description ?? 'No hay descripción disponible.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (product.specs != null && product.specs!.isNotEmpty) ...[
                    const Text(
                      'Especificaciones Técnicas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Usamos el `...` (spread operator) para añadir los widgets a la columna
                    ...product.specs!.map((spec) => _SpecItem(spec)).toList(),
                  ],
                  
                  const SizedBox(height: 30),

                  // DEMOS DINÁMICOS DEPENDIENDO DEL TIPO
                  if (product.productType == 'vinilo') _buildAudioDemo(),
                  if (product.productType == 'instrumento') _buildVideoDemo(),
                  if (product.productType == 'iluminacion') _buildLightingDemo(),

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
                        icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 16),
                        label: const Text('Agregar', style: TextStyle(color: Colors.white, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurpleHover,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text('Comprar Ahora', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES DE DEMO (Sin cambios) ---
  Widget _buildAudioDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Demo de Audio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        const Text('Prueba de Sonido (Video)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=600'),
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
          ),
          child: const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48)),
        ),
      ],
    );
  }

  Widget _buildLightingDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Simulador de Colores DMX', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        const Text('Selecciona un color para ver una vista previa.', style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

// --- WIDGETS INTERNOS ---

class _ColorCircle extends StatelessWidget {
  final Color color;
  const _ColorCircle(this.color);

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
            color: color.withValues(alpha: 0.4),
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
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

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
  const _Thumbnail(this.url);

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
  const _SpecItem(this.text);

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
