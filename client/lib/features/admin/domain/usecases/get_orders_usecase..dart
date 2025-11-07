import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrdersUsecase {
  final OrderRepository repo;
  GetOrdersUsecase(this.repo);

  Future<List<OrderEntity>> call() => repo.getAllOrders();
}
