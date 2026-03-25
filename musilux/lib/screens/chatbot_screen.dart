import 'package:flutter/material.dart';
import 'package:musilux/theme/colors.dart';
import '../services/openai_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController controller = TextEditingController();
  final OpenAIService service = OpenAIService();
  final ScrollController scrollController = ScrollController();

  // 🔥 Historial del chat
  List<Map<String, String>> chatHistory = [
    {
      "role": "system",
      "content":
          "Eres un asistente de Musilux. Ayudas a los usuarios a obtener información sobre nuestros productos, responde de forma clara y amigable."
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

    try {
      final reply = await service.sendMessage(chatHistory);

      setState(() {
        messages.add({"role": "bot", "text": reply});
        chatHistory.add({"role": "assistant", "content": reply});
      });

      _scrollToBottom();
    } catch (e) {
      print("ERROR: $e");
      setState(() {
        messages.add({
          "role": "bot",
          "text": "Error al conectar con el chatbot"
        });
      });

      _scrollToBottom();
    }
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