class OrderEntity {
  final String id;
  final String userId;
  final String? userName;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;
  final String? qrCode;

  OrderEntity({
    required this.id,
    required this.userId,
    this.userName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.qrCode,
  });
}

class OrderItemEntity {
  final String itemId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItemEntity({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}
