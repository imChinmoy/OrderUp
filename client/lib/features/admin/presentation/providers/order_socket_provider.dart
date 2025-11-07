import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/datasource/socket_order_datasource.dart';
import '../../data/models/order_model.dart';

final adminOrdersStreamProvider = StreamProvider<List<OrderEntity>>((ref) {
  final socket = SocketOrderDataSource();
  List<OrderEntity> buffer = [];

  socket.connect(userId: "admin", isAdmin: true);

  final controller = StreamController<List<OrderEntity>>();

  socket.listenNewOrders().listen((OrderModel model) {
    final entity = model.toEntity();
    buffer = [...buffer, entity];
    controller.add(buffer);
  });

  socket.listenCancelled().listen((cancelled) {
    buffer = buffer.where((o) => o.id != cancelled['orderId']).toList();
    controller.add(buffer);
  });


  ref.onDispose(() {
    socket.disconnect();
    controller.close();
  });


  controller.add([]);

  return controller.stream;
});
