import 'package:client/features/chatbot/data/datasource/chatQuery.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/message_entity.dart';

final chatbotProvider =
    StateNotifierProvider<ChatbotNotifier, List<MessageEntity>>((ref) {
  return ChatbotNotifier(ChatbotRemoteDataSource());
});

class ChatbotNotifier extends StateNotifier<List<MessageEntity>> {
  final ChatbotRemoteDataSource remote;
  ChatbotNotifier(this.remote) : super([]) {
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    state = [
      MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Hi! 👋 I'm your food assistant. Ask anything!",
        isUser: false,
        timestamp: DateTime.now(),
      )
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    state = [
      ...state,
      MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      )
    ];

    final reply = await remote.getBotReply(text);

    state = [
      ...state,
      MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      )
    ];
  }

  void clearChat() {
    state = [];
    _addWelcomeMessage();
  }
}
