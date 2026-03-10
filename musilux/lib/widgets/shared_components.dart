import 'package:flutter/material.dart';
import 'package:musilux/product.dart'; // Importa el modelo Product
import 'package:musilux/theme/colors.dart';

// Asumo que BaseLayout ya está definido aquí o en otro archivo común.
class BaseLayout extends StatelessWidget {
  final Widget child;
  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Proporciona un Scaffold básico para las pantallas.
    // Las pantallas pueden añadir su propio AppBar si lo necesitan.
    return Scaffold(body: child);
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isSale; // Para indicar si el producto está en oferta
  final VoidCallback onDetailsTap;

  const ProductCard({
    super.key,
    required this.product,
    this.isSale = false, // Por defecto, no está en oferta
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetailsTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(25),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
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
              child: Image.network(
                product.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSale ? AppColors.priceSale : AppColors.priceText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Muestra la categoría como una etiqueta
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tagBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.tagText,
                        fontWeight: FontWeight.w500,
                      ),
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

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black.withAlpha(100)),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
