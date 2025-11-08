import 'package:client/features/chatbot/domain/repositories/char_repo.dart';

import '../entities/message_entity.dart';

class SendMessageUsecase {
  final ChatbotRepository repo;
  SendMessageUsecase(this.repo);

  Future<MessageEntity> call(String userText) => repo.sendToServer(userText);
}
