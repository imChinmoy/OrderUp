import 'dart:async';
import 'dart:developer' as dev;
import 'package:client/core/api_endpoints.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/order_model.dart';

class SocketOrderDataSource {
  late IO.Socket socket;

  void connect(String userId, {bool isAdmin = false}) {
    socket = IO.io(
      {ApiConfig.baseUrl}, // ⭐ CHANGE THIS
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({
            "userId": userId,
            "role": isAdmin ? "admin" : "student",
          })
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      dev.log("✅ Socket connected");

      if (isAdmin) {
        socket.emit("joinAdminRoom");
      } else {
        socket.emit("joinUserRoom", userId);
      }
    });

    socket.onDisconnect((_) {
      dev.log("⚠️ Socket disconnected");
    });
  }

  Stream<OrderModel> listenForNewOrders() {
    final controller = StreamController<OrderModel>();

    socket.on("newOrder", (data) {
      controller.add(OrderModel.fromJson(data));
    });

    return controller.stream;
  }

  Stream<OrderModel> listenForStatusUpdates() {
    final controller = StreamController<OrderModel>();

    socket.on("orderUpdated", (data) {
      controller.add(OrderModel.fromJson(data));
    });

    return controller.stream;
  }

  Stream<Map<String, dynamic>> listenForCancelled() {
    final controller = StreamController<Map<String, dynamic>>();

    socket.on("orderCancelled", (data) {
      controller.add(Map<String, dynamic>.from(data));
    });

    return controller.stream;
  }

  void disconnect() {
    socket.dispose();
    dev.log("🔌 Socket disconnected and disposed");
  }
}
