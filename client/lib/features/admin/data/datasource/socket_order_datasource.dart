import 'dart:async';
import 'dart:developer' as dev;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/order_model.dart';
import 'package:client/core/api_endpoints.dart';

class SocketOrderDataSource {
  IO.Socket? _socket;

  void connect({required bool isAdmin, required String userId}) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      ApiConfig.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      dev.log("✅ Socket connected");

      _socket!.emit("join", {
        "role": isAdmin ? "admin" : "student",
        "userId": userId,
      });
    });

    _socket!.onDisconnect((_) => dev.log("⚠️ Socket disconnected"));
  }

  Stream<OrderModel> listenNewOrders() {
    final controller = StreamController<OrderModel>();
    _socket!.on("newOrder", (data) => controller.add(OrderModel.fromJson(data)));
    return controller.stream;
  }

  Stream<OrderModel> listenStatusUpdates() {
    final controller = StreamController<OrderModel>();
    _socket!.on("orderUpdated", (data) => controller.add(OrderModel.fromJson(data)));
    return controller.stream;
  }

  Stream<Map<String, dynamic>> listenCancelled() {
    final controller = StreamController<Map<String, dynamic>>();
    _socket!.on("orderCancelled", (data) => controller.add(Map<String, dynamic>.from(data)));
    return controller.stream;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    dev.log("🔌 Socket disposed");
  }
}
