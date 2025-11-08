class MessageEntity {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}