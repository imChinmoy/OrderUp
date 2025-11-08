import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/datasource/socket_order_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';

final orderRepositoryProvider = Provider(
  (ref) => OrderRepositoryImpl(SocketOrderDataSource()),
);

final adminOrdersStreamProvider = StreamProvider<List<OrderEntity>>((ref) async* {
  dev.log("📌 Provider started");
  final socket = SocketOrderDataSource();
  final repo = OrderRepositoryImpl(socket);

  List<OrderEntity> orders = [];

  final oldOrders = await repo.getAllOrders();
  orders = [...oldOrders];
  yield orders;

  socket.connect(isAdmin: true, userId: "admin");

  socket.listenNewOrders().listen((m) {
    orders = [...orders, m.toEntity()];
    ref.state = AsyncData(orders);
  });

  socket.listenStatusUpdates().listen((m) {
    final updated = m.toEntity();
    orders = orders.map((o) => o.id == updated.id ? updated : o).toList();
    ref.state = AsyncData(orders);
  });

  socket.listenCancelled().listen((cancelled) {
    orders = orders.where((o) => o.id != cancelled['orderId']).toList();
    ref.state = AsyncData(orders);
  });

  ref.onDispose(socket.disconnect);
});

