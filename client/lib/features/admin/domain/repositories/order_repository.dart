import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getAllOrders();
  Stream<OrderEntity> listenForNewOrders();
  Stream<OrderEntity> listenForStatusUpdates();
  Stream<Map<String, dynamic>> listenForCancelled();
}
