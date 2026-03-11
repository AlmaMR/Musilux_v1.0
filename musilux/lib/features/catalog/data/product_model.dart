class ProductModel {
  final String? id;
  final String nombre;
  final String slug;
  final String? descripcion;
  final String tipoProducto;
  final double precio;
  final int inventario;
  final int? bpm;
  final bool estaActivo;

  ProductModel({
    this.id,
    required this.nombre,
    required this.slug,
    this.descripcion,
    required this.tipoProducto,
    required this.precio,
    required this.inventario,
    this.bpm,
    this.estaActivo = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString(),
      nombre: json['nombre'] ?? '',
      slug: json['slug'] ?? '',
      descripcion: json['descripcion'],
      tipoProducto: json['tipo_producto'] ?? 'fisico',
      // Manejo seguro de tipos numéricos (Laravel puede enviar string, int o double)
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      inventario: int.tryParse(json['inventario'].toString()) ?? 0,
      bpm: json['bpm'] != null ? int.tryParse(json['bpm'].toString()) : null,
      estaActivo: json['esta_activo'] == 1 || json['esta_activo'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'slug': slug,
      'descripcion': descripcion,
      'tipo_producto': tipoProducto,
      'precio': precio,
      'inventario': inventario,
      'bpm': bpm,
      'esta_activo': estaActivo,
    };
  }
}
