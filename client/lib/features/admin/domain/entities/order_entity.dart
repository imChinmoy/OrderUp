class OrderEntity {
  final String id;
  final String userId;
  final List<dynamic> items;
  final double totalAmount;
  final String status;

  OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
  });
}
