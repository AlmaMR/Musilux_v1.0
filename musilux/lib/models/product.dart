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
  final int categoryId; // OBLIGATORIO en backend
  final int? bpm; // Opcional en backend

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
    this.categoryId = 1, // Por defecto 1 si no se envía
    this.bpm,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Factory actualizado para coincidir con la estructura del API Resource de Laravel.
    // Esto asegura que los datos siempre tengan el mismo formato.
    return Product(
      id: json['id']?.toString() ?? '0',
      title: (json['title'] ?? 'Sin título').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: (json['imageUrl'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isSale:
          json['isSale'] ??
          false, // El backend ahora envía 'isSale' como booleano
      description: json['description'] as String?,
      specs: json['specs'] != null ? List<String>.from(json['specs']) : null,
      productType: json['productType'] as String?,
      categoryId: int.tryParse(json['categoria_id']?.toString() ?? '1') ?? 1,
      bpm: json['bpm'] != null ? int.tryParse(json['bpm'].toString()) : null,
    );
  }

  // Método para enviar datos al Backend (SQL)
  Map<String, dynamic> toJson() {
    return {
      'categoria_id': categoryId,
      'nombre': title,
      'precio': price,
      'descripcion': description,
      'inventario': stock,
      'tipo_producto': productType ?? 'fisico',
      'bpm': bpm,
      'esta_activo': isSale,
    };
  }
}
