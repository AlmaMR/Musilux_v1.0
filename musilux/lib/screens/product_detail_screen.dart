import 'package:flutter/material.dart';
import 'package:musilux/models/product.dart';
import 'package:musilux/services/api_service.dart';
import '../theme/colors.dart';
import '../widgets/shared_components.dart';
import 'package:audioplayers/audioplayers.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId; // Agregado para recibir desde la URL
  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productFuture;
  final ApiService _apiService = ApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _productId;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extraemos el ID del producto de los argumentos de la ruta.
    // Lo hacemos aquí porque ModalRoute.of(context) no está disponible en initState.
    final args = ModalRoute.of(context)?.settings.arguments;

    // Damos prioridad al ID que viene inyectado por la URL (widget.productId)
    final extractedId = widget.productId ?? args?.toString();

    // Si el ID cambia (o es la primera vez), iniciamos una nueva carga.
    if (extractedId != null && extractedId != _productId) {
      setState(() {
        _productId = extractedId;
        _productFuture = _apiService.fetchProductById(_productId!);
      });
    } else if (_productId == null) {
      // Manejo de caso donde no se pasa ID
      setState(() {
        _productFuture = Future.error('No se proporcionó un ID de producto.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: FutureBuilder<Product>(
                future: _productFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Producto no encontrado.'));
                  }

                  final product = snapshot.data!;

                  return Row(
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
                                product.imageUrl,
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (product.multimedia.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_back_ios, size: 16),
                                  const SizedBox(width: 10),
                                  ...product.multimedia.map(
                                    (media) => Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: _Thumbnail(media.urlArchivo),
                                    ),
                                  ),
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
                              // CHIP DE CATEGORÍA
                              if (product.categoria != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPurple.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    product.categoria!.nombre.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              Text(
                                product.nombre,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // AÑADIDO: Muestra el ID real generado en la base de datos
                              SelectableText(
                                'Ref (ID): ${product.id}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                // El precio viene como double, lo formateamos.
                                '\$${product.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // INVENTARIO Y BPM
                              Row(
                                children: [
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    product.inventario > 0
                                        ? 'Stock: ${product.inventario} disponibles'
                                        : 'Agotado',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: product.inventario > 0
                                          ? Colors.green[700]
                                          : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (product.bpm != null) ...[
                                    const SizedBox(width: 20),
                                    const Icon(
                                      Icons.speed,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'BPM: ${product.bpm}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 16),

                              Text(
                                product.descripcion ??
                                    'No hay descripción disponible.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 30),

                              // DEMOS DINÁMICOS DEPENDIENDO DEL TIPO
                              if (product.tipoProducto == 'digital')
                                _buildAudioDemo(),
                              if (product.tipoProducto == 'fisico')
                                _buildSpotifyDemo(product),
                              if (product.tipoProducto == 'servicio')
                                _buildLightingDemo(),

                              const SizedBox(height: 40),

                              // Botones de Compra
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                                      backgroundColor: AppColors.primaryPurple,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.primaryPurpleHover,
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES DE DEMO (Sin cambios) ---
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

  Widget _buildSpotifyDemo(Product product) {
    if (product.spotifyPreviewUrl == null) {
      return const SizedBox.shrink(); // Sin preview, no muestra nada
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎵 Demo de la Canción',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (product.spotifyAlbumImageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    product.spotifyAlbumImageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.spotifyTrackName ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.spotifyArtistName ?? '',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Preview 30s',
                      style: TextStyle(color: Color(0xFF1DB954), fontSize: 11),
                    ),
                  ],
                ),
              ),
              StatefulBuilder(
                builder: (context, setInner) => IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: const Color(0xFF1DB954),
                    size: 44,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                      setInner(() => _isPlaying = false);
                    } else {
                      await _audioPlayer.play(
                        UrlSource(product.spotifyPreviewUrl!),
                      );
                      setInner(() => _isPlaying = true);
                      _audioPlayer.onPlayerComplete.listen((_) {
                        if (mounted) setInner(() => _isPlaying = false);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
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
