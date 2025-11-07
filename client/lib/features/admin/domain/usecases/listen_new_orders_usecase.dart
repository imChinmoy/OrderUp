import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class ListenNewOrdersUsecase {
  final OrderRepository repo;
  ListenNewOrdersUsecase(this.repo);

  Stream<OrderEntity> call() => repo.listenForNewOrders();
}
