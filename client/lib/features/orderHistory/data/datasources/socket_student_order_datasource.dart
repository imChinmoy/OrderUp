import 'dart:async';
import 'dart:developer' as dev;
import 'package:client/features/admin/data/models/order_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:client/core/api_endpoints.dart';

class StudentOrderSocketDataSource {
  IO.Socket? _socket;

  void connect(String userId) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      ApiConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      dev.log("✅ Student socket connected");
      _socket!.emit("join", "user:$userId"); 
      dev.log("📌 JOINED student room: $userId");
    });

    _socket!.on("disconnect", (_) => dev.log("⚠️ Student socket disconnected"));
  }

  Stream<OrderModel> listenUpdates() {
    final controller = StreamController<OrderModel>();
    _socket?.on("orderUpdated", (data) {
      dev.log("🔥 Student orderUpdated received");
      controller.add(OrderModel.fromJson(data));
    });
    return controller.stream;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
