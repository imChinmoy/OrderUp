// import 'dart:async';

// import 'package:client/features/admin/data/datasource/socket_service.dart';

// import '../../domain/entities/order_entity.dart';
// import '../../domain/repositories/order_repository.dart';

// class OrderRepositoryImpl implements OrderRepository {
//   final SocketService socketService;
//   final StreamController<List<OrderEntity>> _orderController =
//       StreamController.broadcast();

//   OrderRepositoryImpl(this.socketService) {
//     socketService.connect();

//     socketService.socket.on('new_order', (data) {
//       // Parse new order data and add to stream
//       final order = OrderEntity(
//           id: data['id'],
//           itemName: data['itemName'],
//           quantity: data['quantity'],
//           status: data['status']);

//       // For demo, emit single new order as list
//       _orderController.add([order]);
//     });
//   }

//   @override
//   Stream<List<OrderEntity>> getOrdersStream() {
//     return _orderController.stream;
//   }

//   void dispose() {
//     _orderController.close();
//     socketService.dispose();
//   }
// }
