class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String slug; // Nuevo campo SQL
  final int stock; // Nuevo campo SQL (inventario)
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
    this.slug = '',
    this.stock = 0,
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
      id: json['id']?.toString() ?? '0',
      title: (json['title'] ?? json['titulo'] ?? 'Sin título').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: (json['imageUrl'] ?? json['img'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      stock: (json['inventario'] as num?)?.toInt() ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isSale:
          json['esta_activo'] == 1 ||
          json['esta_activo'] == true, // Mapeo a boolean
      description: json['desc'] as String?,
      specs: json['specs'] != null ? List<String>.from(json['specs']) : null,
      productType: json['tipo_producto'] as String?,
    );
  }

  // Método para enviar datos al Backend (SQL)
  Map<String, dynamic> toJson() {
    return {
      'nombre': title,
      'slug': slug.isEmpty
          ? title.toLowerCase().replaceAll(' ', '-')
          : slug, // Generación simple de slug
      'precio': price,
      'descripcion': description,
      'inventario': stock,
      'tipo_producto': productType ?? 'fisico',
      // Asumimos que el backend maneja la imagen recibiendo una URL por ahora
      'url_imagen': imageUrl,
      'esta_activo': isSale,
    };
  }
}
