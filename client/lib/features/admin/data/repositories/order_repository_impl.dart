import 'package:client/features/admin/domain/repositories/order_repository.dart';
import '../datasource/socket_order_datasource.dart';
import '../../domain/entities/order_entity.dart';

class OrderRepositoryImpl implements OrderRepository {
  final SocketOrderDataSource datasource;
  OrderRepositoryImpl(this.datasource);

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    // You already hit GET /api/orders in another repo (not socket)
    // If needed, implement here. Returning empty for now:
    return [];
  }

  @override
  Stream<OrderEntity> listenForNewOrders() =>
      datasource.listenNewOrders().map((m) => m.toEntity());

  @override
  Stream<OrderEntity> listenForStatusUpdates() =>
      datasource.listenStatusUpdates().map((m) => m.toEntity());

  @override
  Stream<Map<String, dynamic>> listenForCancelled() =>
      datasource.listenCancelled();
}
