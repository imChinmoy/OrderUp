import 'package:client/features/admin/domain/entities/order_entity.dart';
import 'package:client/features/orderHistory/data/datasources/socket_student_order_datasource.dart';

class StudentOrderRepositoryImpl {
  final StudentOrderSocketDataSource socket;
  StudentOrderRepositoryImpl(this.socket);

  Stream<OrderEntity> onOrderUpdated() {
    return socket.listenUpdates().map((m) => m.toEntity());
  }
}
