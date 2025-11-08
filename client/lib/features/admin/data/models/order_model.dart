import 'package:client/features/admin/domain/entities/order_entity.dart';

class OrderModel {
  final String id;
  final String userId;
  final String? userName;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.userName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final u = json['userId'];

    return OrderModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userId: u is Map ? (u['_id']?.toString() ?? '') : (u?.toString() ?? ''),
      userName: u is Map ? (u['name']?.toString() ?? '') : '',
      items: (json['items'] as List? ?? [])
          .map((i) => OrderItemModel.fromJson(i))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'received',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  OrderEntity toEntity() => OrderEntity(
        id: id,
        userId: userId,
        userName: userName,
        items: items.map((e) => e.toEntity()).toList(),
        totalAmount: totalAmount,
        status: status,
        paymentStatus: paymentStatus,
        createdAt: createdAt,
      );
}

class OrderItemModel {
  final String itemId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItemModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      itemId: json['itemId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Item',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  OrderItemEntity toEntity() => OrderItemEntity(
        itemId: itemId,
        name: name,
        quantity: quantity,
        price: price,
        imageUrl: imageUrl,
      );
}
