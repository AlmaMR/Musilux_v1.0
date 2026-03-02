import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/shared_components.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Container(
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
                        'https://images.unsplash.com/photo-1526478806334-5fd488fcaabc?w=600',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, size: 16),
                        SizedBox(width: 10),
                        _Thumbnail(
                          'https://images.unsplash.com/photo-1526478806334-5fd488fcaabc?w=100',
                        ),
                        SizedBox(width: 10),
                        _Thumbnail(
                          'https://images.unsplash.com/photo-1619983081563-430f63602796?w=100',
                        ),
                        SizedBox(width: 10),
                        _Thumbnail(
                          'https://images.unsplash.com/photo-1484882195048-0d3ee78b87ee?w=100',
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios, size: 16),
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
                    const Text(
                      'In Utero',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$599.99',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '"In Utero" es una grabación aullante y desafiantemente punk, un retroceso poco sentimental a una era de epifanías de bandas de garaje y rock and roll crudo y sin adornos. Nirvana arremete contra la conformidad alternativa...',
                      style: TextStyle(
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
                    const _SpecItem(
                      'Producto descontinuado por el fabricante: No',
                    ),
                    const _SpecItem(
                      'Dimensiones del producto: 31,29 x 31,39 x 1,19 cm; 235,87 g',
                    ),
                    const _SpecItem('Referencia del fabricante: GEF24536'),
                    const _SpecItem('ASIN: B00004WP7P'),
                    const _SpecItem('Número de discos: 1'),
                    const SizedBox(height: 30),

                    // Demo Audio Player
                    const Text(
                      'Demo de Audio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.skip_previous, size: 30),
                        SizedBox(width: 20),
                        Icon(Icons.play_arrow, size: 40),
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
                            color: Colors.grey.shade300,
                            alignment: Alignment.centerLeft,
                            child: Container(width: 100, color: Colors.black),
                          ),
                        ),
                        const Text('01:00', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Botones
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
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const CheckoutModal(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('Comprar Ahora'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
