import 'dart:async';
import 'dart:developer' as dev;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:client/core/api_endpoints.dart';
import '../models/order_model.dart';

class SocketOrderDataSource {
  IO.Socket? _socket;

  void connect({required bool isAdmin, required String userId}) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      ApiConfig.baseUrl.replaceAll("/api", ""),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      dev.log("✅ Socket connected");

      _socket!.emit("join", [isAdmin ? "admin" : "student", userId]);
      dev.log("📌 Sent JOIN => role: ${isAdmin ? 'admin' : 'student'} , user: $userId");
    });

    _socket!.on("connect_error", (err) => dev.log("❌ Connect error: $err"));
    _socket!.on("disconnect", (_) => dev.log("⚠️ Socket disconnected"));
  }

  Stream<OrderModel> listenNewOrders() {
    final controller = StreamController<OrderModel>();
    _socket?.on("newOrder", (data) {
      dev.log("🔥 newOrder received");
      controller.add(OrderModel.fromJson(data));
    });
    return controller.stream;
  }

  Stream<OrderModel> listenStatusUpdates() {
    final controller = StreamController<OrderModel>();
    _socket?.on("orderUpdated", (data) {
      controller.add(OrderModel.fromJson(data));
    });
    return controller.stream;
  }

  Stream<Map<String, dynamic>> listenCancelled() {
    final controller = StreamController<Map<String, dynamic>>();
    _socket?.on("orderCancelled", (data) {
      controller.add(Map<String, dynamic>.from(data));
    });
    return controller.stream;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
