import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ApiService {
  // Usamos 10.0.2.2 para conectar al localhost de la máquina host desde el emulador de Android.
  // El puerto 8000 es el default de `php artisan serve`.
  final String _baseUrl = kIsWeb ? 'http://localhost:8000/api' : 'http://10.0.2.2:8000/api';

  Future<List<Product>> fetchProducts({String? category}) async {
    // El backend espera el slug de la categoría, no el nombre.
    // Ejemplo: /api/products?category=guitarras
    String url = '$_baseUrl/products';
    if (category != null && category.isNotEmpty) {
      url += '?category=$category';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // La API de Laravel envuelve la data en una clave "data" por defecto en los Resources.
        final List<dynamic> productData = json.decode(response.body)['data'];
        return productData.map((json) => Product.fromJson(json)).toList();
      } else {
        // Log del error para facilitar el debugging.
        print('Error en la petición: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        throw Exception('Falló al cargar los productos');
      }
    } catch (e) {
      // Captura errores de conexión o parsing.
      print('Error de conexión o al procesar la respuesta: $e');
      throw Exception('No se pudo conectar al servidor o procesar la respuesta.');
    }
  }

  Future<Product> fetchProductById(String id) async {
    final String url = '$_baseUrl/products/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // El resource de detalle también envuelve la respuesta en "data".
        final dynamic productData = json.decode(response.body)['data'];
        return Product.fromJson(productData);
      } else {
        print('Error en la petición: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        throw Exception('Falló al cargar el producto con id $id');
      }
    } catch (e) {
      print('Error de conexión o al procesar la respuesta: $e');
      throw Exception('No se pudo conectar al servidor o procesar la respuesta.');
    }
  }
}
