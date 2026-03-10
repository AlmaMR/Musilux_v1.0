import 'package:musilux/features/catalog/data/product_model.dart';

class ProductService {
  // Simula la obtención de productos desde una API
  Future<List<ProductModel>> getProducts() async {
    // Simula un retraso de red
    await Future.delayed(const Duration(seconds: 2));

    // Datos estáticos para demostración, que coinciden con la estructura de ProductModel
    return [
      ProductModel(
        id: 'promo-001',
        name: 'Guitarra Eléctrica Fender Stratocaster',
        description:
            'La icónica Fender Stratocaster, sonido clásico y versátil para cualquier género musical.',
        price: 18500.00,
        imageUrl:
            'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=600&q=80',
        category: 'Guitarras',
      ),
      ProductModel(
        id: 'promo-002',
        name: 'Máquina de Humo Profesional 1500W',
        description:
            'Potente máquina de humo para escenarios grandes, ideal para conciertos y eventos.',
        price: 1200.00,
        imageUrl:
            'https://m.media-amazon.com/images/I/61cflmAri4L._AC_UF1000,1000_QL80_.jpg',
        category: 'Iluminación',
      ),
      ProductModel(
        id: 'promo-003',
        name: 'Vinilo "Nevermind" - Nirvana',
        description:
            'El legendario álbum de Nirvana en formato vinilo, una pieza esencial para coleccionistas.',
        price: 599.99,
        imageUrl:
            'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=600&q=80',
        category: 'Vinilos',
      ),
      ProductModel(
        id: 'promo-004',
        name: 'Bajo Eléctrico Ibanez SR300',
        description:
            'Bajo de 4 cuerdas con gran versatilidad tonal y comodidad, perfecto para bajistas exigentes.',
        price: 7200.00,
        imageUrl: 'https://m.media-amazon.com/images/I/71KHUkwn3WL.jpg',
        category: 'Bajos',
      ),
      // Puedes añadir más productos de ejemplo aquí
    ];
  }
}
