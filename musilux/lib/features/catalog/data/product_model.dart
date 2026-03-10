import 'package:musilux/product.dart'; // Import the base Product class

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
  });

  // Factory constructor para crear un ProductModel desde un JSON (ej. de una API)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['nombre'] as String,
      description: json['descripcion'] as String,
      price: (json['precio'] as num).toDouble(),
      // Asume que la API proporciona 'imageUrl' y 'category'
      // Si no, necesitarás mapearlos desde otros campos o proporcionar valores por defecto
      imageUrl:
          json['imageUrl'] as String? ?? 'https://via.placeholder.com/150',
      category: json['category'] as String? ?? 'General',
    );
  }

  // Puedes añadir más métodos o propiedades específicas de la capa de datos aquí
}
