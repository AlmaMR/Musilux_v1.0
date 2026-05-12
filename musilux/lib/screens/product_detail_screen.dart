import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:musilux/models/product.dart';
import 'package:musilux/services/api_service.dart';
import '../providers/cart_provider.dart';
import '../theme/colors.dart';
import '../widgets/shared_components.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId;
  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<Product> _productFuture;
  final ApiService _apiService = ApiService();
  String? _productId;

  late PageController _pageController;
  int _currentImageIndex = 0;
  bool _expandDescription = false;

  // Skeleton pulse animation
  late AnimationController _skeletonCtrl;
  late Animation<double> _skeletonAnim;

  bool get _isMobile => MediaQuery.of(context).size.width < 800;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _skeletonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _skeletonAnim = Tween<double>(
      begin: 0.35,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _skeletonCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _skeletonCtrl.dispose();
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
        _currentImageIndex = 0;
        _expandDescription = false;
        _productFuture = _apiService.fetchProductById(_productId!);
      });
      if (_pageController.hasClients) _pageController.jumpToPage(0);
    } else if (_productId == null) {
      setState(() {
        _productFuture = Future.error('No se proporcionó un ID de producto.');
      });
    }
  }

  void _agregarAlCarrito(
    BuildContext context,
    Product product, {
    bool abrirCarrito = false,
  }) {
    final cart = context.read<CartProvider>();
    final resultado = cart.agregarProducto(
      productoId: product.id,
      nombre: product.nombre,
      precio: product.precio,
      imagenUrl: product.imageUrl,
      stockDisponible: product.inventario,
    );

    String mensaje;
    Color color;

    switch (resultado) {
      case CartAddResult.exito:
        mensaje = '${product.nombre} agregado al carrito';
        color = AppColors.success;
        if (abrirCarrito) Scaffold.of(context).openEndDrawer();
        break;
      case CartAddResult.sinStock:
        mensaje = 'Sin stock disponible';
        color = AppColors.error;
      case CartAddResult.limiteNegocio:
        mensaje = 'Máximo 10 unidades por producto';
        color = AppColors.warning;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────

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
                return _buildSkeleton();
              }
              if (snapshot.hasError) {
                return _buildError(snapshot.error.toString());
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

  Widget _buildError(String error) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              'Error: $error',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ── Skeleton Loader ────────────────────────────────────────────

  Widget _buildSkeleton() {
    return AnimatedBuilder(
      animation: _skeletonAnim,
      builder: (_, _) {
        final opacity = _skeletonAnim.value;

        Widget box({double w = double.infinity, double h = 20, double r = 6}) =>
            Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(r),
              ),
            );

        final imageBlock = box(h: 300, r: 12);
        final thumbnailRow = Row(
          children: List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: box(w: 64, h: 64, r: 8),
            ),
          ),
        );
        final infoBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            box(w: 80, h: 24, r: 12),
            const SizedBox(height: 12),
            box(h: 28),
            const SizedBox(height: 8),
            box(w: 200, h: 28),
            const SizedBox(height: 12),
            box(w: 130, h: 34, r: 4),
            const SizedBox(height: 16),
            box(w: 170, h: 18),
            const SizedBox(height: 16),
            box(h: 14),
            const SizedBox(height: 6),
            box(h: 14),
            const SizedBox(height: 6),
            box(w: 240, h: 14),
            const SizedBox(height: 32),
            box(h: 50, r: 10),
          ],
        );

        if (_isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageBlock,
              const SizedBox(height: 12),
              thumbnailRow,
              const SizedBox(height: 24),
              infoBlock,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  imageBlock,
                  const SizedBox(height: 12),
                  thumbnailRow,
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(flex: 5, child: infoBlock),
          ],
        );
      },
    );
  }

  // ── Layouts ────────────────────────────────────────────────────

  Widget _buildMobileLayout(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageColumn(product),
        const SizedBox(height: 24),
        _buildInfoColumn(product),
        if (_productId != null) _buildRelatedProducts(_productId!),
      ],
    );
  }

  Widget _buildDesktopLayout(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: _buildImageColumn(product)),
            const SizedBox(width: 40),
            Expanded(flex: 5, child: _buildInfoColumn(product)),
          ],
        ),
        if (_productId != null) _buildRelatedProducts(_productId!),
      ],
    );
  }

  // ── Galería con carousel y swipe ───────────────────────────────

  Widget _buildImageColumn(Product product) {
    final imageMedia = product.multimedia
        .where((m) => m.tipoMultimedia == 'imagen')
        .toList();
    final urls = imageMedia.isNotEmpty
        ? imageMedia.map((m) => m.urlArchivo).toList()
        : <String>[product.imageUrl];

    return Column(
      children: [
        Semantics(
          label: 'Galería de imágenes de ${product.nombre}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: _isMobile ? 300.0 : 520.0,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentImageIndex = i),
                itemCount: urls.length,
                itemBuilder: (_, i) => CachedNetworkImage(
                  imageUrl: urls[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  filterQuality: FilterQuality.high,
                  memCacheHeight: _isMobile ? 900 : 1560,
                  placeholder: (_, _) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Tira de miniaturas — visible solo si hay más de 1 imagen
        if (urls.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 68,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: urls.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => Semantics(
                label: 'Imagen ${i + 1} de ${urls.length}',
                button: true,
                child: GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                  ),
                  child: _ThumbnailTile(
                    url: urls[i],
                    isActive: _currentImageIndex == i,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Columna de información ─────────────────────────────────────

  Widget _buildInfoColumn(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chip de categoría
        if (product.categoria != null)
          Semantics(
            label: 'Categoría: ${product.categoria!.nombre}',
            child: Container(
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
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  product.inventario > 0
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  size: 18,
                  color: product.inventario > 0
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 6),
                Text(
                  product.inventario > 0
                      ? 'Stock: ${product.inventario} disponibles'
                      : 'Agotado',
                  style: TextStyle(
                    fontSize: 14,
                    color: product.inventario > 0
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (product.bpm != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.speed,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${product.bpm} BPM',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
          ],
        ),

        // Etiquetas (tags)
        if (product.etiquetas.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: product.etiquetas
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tagBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag.nombre,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.tagText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],

        const SizedBox(height: 16),

        // Descripción colapsable
        if (product.descripcion != null && product.descripcion!.isNotEmpty) ...[
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Text(
              product.descripcion!,
              maxLines: _expandDescription ? null : 3,
              overflow: _expandDescription
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                setState(() => _expandDescription = !_expandDescription),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _expandDescription ? 'Ver menos' : 'Ver más',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    _expandDescription
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.primaryPurple,
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Demos según tipo: Spotify tiene prioridad si hay track asociado
        if (product.spotifyTrackId != null)
          _SpotifyPreviewPlayer(product: product)
        else if (product.tipoProducto == 'digital')
          _buildAudioDemo(),
        if (product.tipoProducto == 'servicio') _buildLightingDemo(),

        const SizedBox(height: 32),

        // Botones de compra
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: product.inventario > 0
                    ? () => _agregarAlCarrito(context, product)
                    : null,
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text(
                  'Agregar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: product.inventario > 0
                    ? () => _agregarAlCarrito(
                        context,
                        product,
                        abrirCarrito: true,
                      )
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryPurple,
                  side: const BorderSide(color: AppColors.primaryPurple),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Comprar Ahora',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Demos ──────────────────────────────────────────────────────

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

  // ── Productos Relacionados ─────────────────────────────────────

  Widget _buildRelatedProducts(String productId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 56),
        const Text(
          'También te puede interesar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Product>>(
          future: _apiService.fetchRelatedProducts(productId),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, _) => Container(
                    width: 140,
                    height: 210,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            }
            if (!snap.hasData || snap.data!.isEmpty) {
              return const SizedBox.shrink();
            }
            final related = snap.data!;
            return SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _RelatedProductCard(
                  product: related[i],
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(productId: related[i].id),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Spotify Preview Player ─────────────────────────────────────

class _SpotifyPreviewPlayer extends StatefulWidget {
  final Product product;
  const _SpotifyPreviewPlayer({required this.product});

  @override
  State<_SpotifyPreviewPlayer> createState() => _SpotifyPreviewPlayerState();
}

class _SpotifyPreviewPlayerState extends State<_SpotifyPreviewPlayer> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  static const Duration _total = Duration(seconds: 30);

  bool get _hasPreview => widget.product.spotifyPreviewUrl != null;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPositionChanged.listen((pos) {
      if (!mounted) return;
      setState(() => _position = pos > _total ? _total : pos);
    });
    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (!_hasPreview) return;
    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      if (_position == Duration.zero) {
        await _player.play(UrlSource(widget.product.spotifyPreviewUrl!));
      } else {
        await _player.resume();
      }
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _openInSpotify() async {
    final trackId = widget.product.spotifyTrackId;
    if (trackId == null) return;
    final uri = Uri.parse('https://open.spotify.com/track/$trackId');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isMobile = MediaQuery.of(context).size.width < 800;
    final progress = (_position.inMilliseconds / _total.inMilliseconds)
        .clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF1DB954),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.music_note, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              _hasPreview ? 'Preview de la canción' : 'Canción asociada',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tarjeta del reproductor
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              // Fila superior: carátula + info + botón
              Row(
                children: [
                  // Carátula del álbum
                  if (p.spotifyAlbumImageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: p.spotifyAlbumImageUrl!,
                        width: isMobile ? 52 : 64,
                        height: isMobile ? 52 : 64,
                        fit: BoxFit.cover,
                        memCacheWidth: 192,
                        memCacheHeight: 192,
                        placeholder: (_, _) => Container(
                          width: isMobile ? 52 : 64,
                          height: isMobile ? 52 : 64,
                          color: const Color(0xFF282828),
                        ),
                        errorWidget: (_, _, _) => Container(
                          width: isMobile ? 52 : 64,
                          height: isMobile ? 52 : 64,
                          color: const Color(0xFF282828),
                          child: const Icon(Icons.album, color: Color(0xFF535353)),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: isMobile ? 52 : 64,
                      height: isMobile ? 52 : 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF282828),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.album, color: Color(0xFF535353)),
                    ),

                  SizedBox(width: isMobile ? 10 : 14),

                  // Nombre de canción y artista
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.spotifyTrackName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 13 : 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          p.spotifyArtistName ?? '',
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1DB954).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _hasPreview ? 'Preview 30s' : 'Spotify',
                            style: const TextStyle(
                              color: Color(0xFF1DB954),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón: play/pause si hay preview, o abrir Spotify si no
                  GestureDetector(
                    onTap: _hasPreview ? _toggle : _openInSpotify,
                    child: Container(
                      width: isMobile ? 44 : 52,
                      height: isMobile ? 44 : 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DB954),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1DB954).withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        _hasPreview
                            ? (_isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded)
                            : Icons.open_in_new_rounded,
                        color: Colors.black,
                        size: isMobile ? 24 : 28,
                      ),
                    ),
                  ),
                ],
              ),

              // Barra de progreso — solo si hay preview
              if (_hasPreview) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      _fmt(_position),
                      style: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 11,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFF3E3E3E),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _isPlaying
                                ? const Color(0xFF1DB954)
                                : const Color(0xFF535353),
                          ),
                          minHeight: isMobile ? 3 : 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _fmt(_total),
                      style: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 11,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ],

              // Mensaje si no hay preview
              if (!_hasPreview) ...[
                const SizedBox(height: 10),
                const Text(
                  'Preview no disponible en esta región. Toca para abrir en Spotify.',
                  style: TextStyle(
                    color: Color(0xFF535353),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 10),

              // Branding Spotify
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1DB954),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.music_note, size: 9, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Spotify',
                    style: TextStyle(
                      color: Color(0xFF1DB954),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Widgets internos ───────────────────────────────────────────

class _ThumbnailTile extends StatelessWidget {
  final String url;
  final bool isActive;
  const _ThumbnailTile({required this.url, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.primaryPurple : Colors.grey.shade200,
          width: isActive ? 2.5 : 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.5),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          memCacheWidth: 192,
          memCacheHeight: 192,
          placeholder: (_, _) => Container(color: AppColors.surfaceVariant),
          errorWidget: (_, _, _) => Container(
            color: AppColors.surfaceVariant,
            child: const Icon(
              Icons.image_not_supported_outlined,
              size: 24,
              color: AppColors.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _RelatedProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 110,
                width: 140,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                memCacheWidth: 420,
                memCacheHeight: 330,
                placeholder: (_, _) =>
                    Container(height: 110, color: AppColors.surfaceVariant),
                errorWidget: (_, _, _) => Container(
                  height: 110,
                  color: AppColors.surfaceVariant,
                  child: const Icon(
                    Icons.music_note,
                    color: AppColors.textDisabled,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
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
}

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
