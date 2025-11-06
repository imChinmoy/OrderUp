import 'package:client/features/admin/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      userId: json['userId'],
      items: json['items'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
    );
  }
}
