import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductService {
  final String baseUrl = "http://10.0.2.2:8080/api/productos";

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  Future<bool> createProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(product.toJson()),
    );

    return response.statusCode == 201;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(product.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
