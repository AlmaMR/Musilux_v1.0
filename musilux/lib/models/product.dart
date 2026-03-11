class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final List<String> tags;
  final bool isSale;
  final String? description;
  final List<String>? specs;
  final String? productType;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.tags = const [],
    this.isSale = false,
    this.description,
    this.specs,
    this.productType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Las claves del JSON de la API deben coincidir con las esperadas aquí.
    // El backend debe devolver 'id', 'title', 'price', 'imageUrl', 'tags', 'isSale' para listas.
    // Y 'titulo', 'precio', 'desc', 'img', 'specs', 'tipo_producto' para el detalle.
    // Este factory intenta ser flexible.
    return Product(
      id: json['id'] as String,
      title: json['title'] ?? json['titulo'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? json['img'] as String,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isSale: json['isSale'] ?? false,
      description: json['desc'] as String?,
      specs: json['specs'] != null ? List<String>.from(json['specs']) : null,
      productType: json['tipo_producto'] as String?,
    );
  }
}
