import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class ChatbotService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<String> sendMessage(String question) async {
    final uri = Uri.parse('$_baseUrl/chatbot');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar la pregunta al chatbot: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['answer'] as String;
  }
}
