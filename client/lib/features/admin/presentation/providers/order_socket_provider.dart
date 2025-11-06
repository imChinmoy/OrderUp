import 'package:client/features/admin/data/datasource/socket_order_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';

final orderSocketProvider = StateNotifierProvider<OrderSocketNotifier, List<OrderModel>>((ref) {
  return OrderSocketNotifier();
});

class OrderSocketNotifier extends StateNotifier<List<OrderModel>> {
  OrderSocketNotifier() : super([]);

  final _datasource = SocketOrderDataSource();

  void connectAsAdmin() {
    _datasource.connect("admin", isAdmin: true);

    _datasource.listenForNewOrders().listen((order) {
      state = [...state, order];
    });

    _datasource.listenForCancelled().listen((cancelled) {
      state = state.where((order) => order.id != cancelled['orderId']).toList();
    });
  }

  void connectAsStudent(String userId) {
    _datasource.connect(userId);

    _datasource.listenForStatusUpdates().listen((order) {
      state = state.map((o) => o.id == order.id ? order : o).toList();
    });
  }

  @override
  void dispose() {
    _datasource.disconnect();
    super.dispose();
  }
}
