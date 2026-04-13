import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musilux/models/product.dart';
import 'package:musilux/services/api_service.dart';
import '../theme/colors.dart';
import '../widgets/shared_components.dart';
import 'package:audioplayers/audioplayers.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId;
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

  bool get _isMobile => MediaQuery.of(context).size.width < 800;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final extractedId = widget.productId ?? args?.toString();
    if (extractedId != null && extractedId != _productId) {
      setState(() {
        _productId = extractedId;
        _productFuture = _apiService.fetchProductById(_productId!);
      });
    } else if (_productId == null) {
      setState(() {
        _productFuture = Future.error('No se proporcionó un ID de producto.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad = _isMobile ? 20.0 : 48.0;
    return BaseLayout(
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPad, 32, hPad, 48),
        child: Container(
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
          padding: EdgeInsets.all(_isMobile ? 20 : 40),
          child: FutureBuilder<Product>(
            future: _productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 12),
                        Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text('Producto no encontrado.')),
                );
              }
              final product = snapshot.data!;
              return _isMobile
                  ? _buildMobileLayout(product)
                  : _buildDesktopLayout(product);
            },
          ),
        ),
      ),
    );
  }

  // ── Layouts ─────────────────────────────────────────────────

  Widget _buildMobileLayout(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageColumn(product),
        const SizedBox(height: 24),
        _buildInfoColumn(product),
      ],
    );
  }

  Widget _buildDesktopLayout(Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildImageColumn(product)),
        const SizedBox(width: 40),
        Expanded(flex: 5, child: _buildInfoColumn(product)),
      ],
    );
  }

  // ── Columna de imagen ────────────────────────────────────────

  Widget _buildImageColumn(Product product) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (ctx, url) => Container(
              height: 300,
              color: AppColors.surfaceVariant,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (ctx, url, err) => Container(
              height: 300,
              color: AppColors.surfaceVariant,
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: AppColors.textDisabled,
              ),
            ),
          ),
        ),
        if (product.multimedia.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.multimedia.length,
              separatorBuilder: (_, i) => const SizedBox(width: 8),
              itemBuilder: (_, i) => _Thumbnail(product.multimedia[i].urlArchivo),
            ),
          ),
        ],
      ],
    );
  }

  // ── Columna de información ───────────────────────────────────

  Widget _buildInfoColumn(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chip de categoría
        if (product.categoria != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              product.categoria!.nombre.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),

        // Nombre
        Text(
          product.nombre,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Precio
        Text(
          '\$${product.precio.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
        ),
        const SizedBox(height: 16),

        // Stock y BPM
        Wrap(
          spacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  product.inventario > 0
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  size: 18,
                  color: product.inventario > 0 ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 6),
                Text(
                  product.inventario > 0
                      ? 'Stock: ${product.inventario} disponibles'
                      : 'Agotado',
                  style: TextStyle(
                    fontSize: 14,
                    color: product.inventario > 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (product.bpm != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.speed, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text('${product.bpm} BPM',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Descripción
        if (product.descripcion != null && product.descripcion!.isNotEmpty)
          Text(
            product.descripcion!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        const SizedBox(height: 24),

        // Demos según tipo
        if (product.tipoProducto == 'digital') _buildAudioDemo(),
        if (product.tipoProducto == 'fisico') _buildSpotifyDemo(product),
        if (product.tipoProducto == 'servicio') _buildLightingDemo(),

        const SizedBox(height: 32),

        // Botones de compra
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agregado al carrito')),
                ),
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Agregar',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirigiendo a pago...')),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryPurple,
                  side: const BorderSide(color: AppColors.primaryPurple),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Comprar Ahora',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Demos ────────────────────────────────────────────────────

  Widget _buildAudioDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Demo de Audio',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    if (product.spotifyPreviewUrl == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Demo de la Canción',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  child: CachedNetworkImage(
                    imageUrl: product.spotifyAlbumImageUrl!,
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
                    Text(product.spotifyTrackName ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        overflow: TextOverflow.ellipsis),
                    Text(product.spotifyArtistName ?? '',
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('Preview 30s',
                        style: TextStyle(color: Color(0xFF1DB954), fontSize: 11)),
                  ],
                ),
              ),
              StatefulBuilder(
                builder: (context, setInner) => IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: const Color(0xFF1DB954),
                    size: 44,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                      setInner(() => _isPlaying = false);
                    } else {
                      await _audioPlayer.play(UrlSource(product.spotifyPreviewUrl!));
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

  Widget _buildLightingDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Simulador de Colores DMX',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        const Text('Selecciona un color para ver una vista previa.',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

// ── Widgets internos ─────────────────────────────────────────

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
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}
