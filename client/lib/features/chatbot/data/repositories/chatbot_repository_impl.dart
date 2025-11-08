import 'package:client/features/chatbot/data/datasource/chatQuery.dart';
import 'package:client/features/chatbot/domain/repositories/char_repo.dart';

import '../../domain/entities/message_entity.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remote;

  ChatbotRepositoryImpl(this.remote);

  @override
  Future<MessageEntity> sendToServer(String userText) async {
    final text = await remote.getBotReply(userText);

    return MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
