import 'package:flutter/material.dart';
import '../services/openai_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController controller = TextEditingController();
  final OpenAIService service = OpenAIService();

  // 🔥 Historial del chat (IMPORTANTE)
  List<Map<String, String>> chatHistory = [
    {
      "role": "system",
      "content":
          "Eres un asistente de Musilux experto en instrumentos, iluminación y vinilos."
    }
  ];

  List<Map<String, String>> messages = [];

  void sendMessage() async {
    final text = controller.text.trim();

    if (text.isEmpty) return; // evita mensajes vacíos

    controller.clear();

    setState(() {
      messages.add({"role": "user", "text": text});
      chatHistory.add({"role": "user", "content": text});
    });

    try {
      final reply = await service.sendMessage(chatHistory);

      setState(() {
        messages.add({"role": "bot", "text": reply});
        chatHistory.add({"role": "assistant", "content": reply});
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() {
        messages.add({
          "role": "bot",
          "text": "Error al conectar con el chatbot"
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot Musilux")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return ListTile(
                  title: Text(msg["text"]!),
                  subtitle: Text(msg["role"]!),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => sendMessage(), // 🔥 ENTER envía
                  decoration: const InputDecoration(
                    hintText: "Escribe un mensaje...",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}