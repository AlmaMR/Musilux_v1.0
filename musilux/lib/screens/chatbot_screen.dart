import 'package:flutter/material.dart';
import 'package:musilux/theme/colors.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController controller = TextEditingController();
  final ApiService apiService = ApiService();
  final ScrollController scrollController = ScrollController();

  // 🔥 Historial del chat
  List<Map<String, String>> chatHistory = [
    {
      "role": "system",
      "content":
          "Eres un asistente virtual de Musilux. Ayudas a los usuarios a obtener información sobre nuestros productos de forma clara, precisa y amigable. "
          "quiero que respondas a las preguntas de los usuarios sobre nuestros productos, promociones, horarios de atención"
          "IMPORTANTE: Nuestra tienda se limita exclusivamente a la venta de vinilos, instrumentos musicales y equipos de iluminación. "
          "Si el usuario pregunta por productos fuera de estas categorías, responde amablemente que no los manejamos y redirige la conversación a nuestras categorías disponibles."
    }
  ];

  List<Map<String, String>> messages = [];

  void sendMessage() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    controller.clear();

    setState(() {
      messages.add({"role": "user", "text": text});
      chatHistory.add({"role": "user", "content": text});
    });

    _scrollToBottom();

    String productSummary = '';
    try {
      final products = await apiService.fetchProducts();
      productSummary = _buildProductSummary(products);
    } catch (e) {
      print('Error cargando productos del backend: $e');
    }

    final requestMessages = List<Map<String, String>>.from(chatHistory);
    
    // Siempre agregar el mensaje del sistema con instrucciones básicas
    requestMessages.insert(0, {
      "role": "system",
      "content": "Eres un asistente virtual de Musilux. Responde en español de forma clara, amable y breve. "
          "Estamos especializados en vinilos, instrumentos musicales y equipos de iluminación. "
          "Si el usuario pregunta por algo fuera de esas categorías, responde que no lo ofrecemos y sugiere alternativas dentro de nuestros productos."
          "${productSummary.isNotEmpty ? '\n\nInformación actualizada de productos y precios desde el backend:\n$productSummary' : ''}"
    });

    try {
      final reply = await apiService.sendChatbotMessages(requestMessages);

      setState(() {
        messages.add({"role": "bot", "text": reply});
        chatHistory.add({"role": "assistant", "content": reply});
      });

      _scrollToBottom();
    } catch (e) {
      print("ERROR en chatbot: $e");
      String errorMessage = "Error al conectar con el chatbot";
      
      if (e.toString().contains('Connection refused')) {
        errorMessage = "No se puede conectar al servidor. Verifica que el backend esté ejecutándose.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Tiempo de espera agotado. El servidor podría estar ocupado.";
      }
      
      setState(() {
        messages.add({
          "role": "bot",
          "text": errorMessage
        });
      });

      _scrollToBottom();
    }
  }

  String _buildProductSummary(List<Product> products) {
    if (products.isEmpty) return '';

    final lines = products.take(15).map((product) {
      final category = product.categoria?.nombre ?? 'Sin categoría';
      final description = product.descripcion?.replaceAll('\n', ' ') ?? '';
      final price = product.precio.toStringAsFixed(2);
      final inventory = product.inventario;

      final base =
          '- ${product.nombre} (${category}) [${product.tipoProducto}] - \$${price} - stock: $inventory';
      return description.isNotEmpty ? '$base - $description' : base;
    }).toList();

    if (products.length > 15) {
      lines.add('...y más productos disponibles.');
    }

    return lines.join('\n');
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  Widget buildMessage(Map<String, String> msg) {
    final isUser = msg["role"] == "user";

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryPurple : AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isUser ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight:
                isUser ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Text(
          msg["text"]!,
          style: TextStyle(
            color: isUser ? AppColors.background : AppColors.headerBg,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot Musilux")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            color: AppColors.background,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => sendMessage(),
                    decoration: const InputDecoration(
                      hintText: "Escribe un mensaje...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: AppColors.primaryPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.background),
                    onPressed: sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}