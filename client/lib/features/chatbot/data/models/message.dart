import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.text,
    required super.isUser,
    required super.timestamp,
  });

  factory MessageModel.fromBot(String reply) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
