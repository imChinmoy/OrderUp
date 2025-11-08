import '../entities/message_entity.dart';

abstract class ChatbotRepository {
  Future<MessageEntity> sendToServer(String userText);
}
