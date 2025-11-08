import 'dart:convert';
import 'package:client/core/api_endpoints.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasource/socket_order_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final SocketOrderDataSource socket;

  OrderRepositoryImpl(this.socket);

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    final session = await HiveSessionStorage().getSession();
    final token = session?.token ?? "";

    final url = Uri.parse("${ApiConfig.baseUrl}${ApiEndpoints.order}");

    final res = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to load orders: ${res.body}");
    }

    final decoded = jsonDecode(res.body);

    if (decoded is! List) {
      throw Exception("Expected List but got: ${decoded.runtimeType}");
    }

    return decoded
        .map((json) => OrderModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Stream<OrderEntity> listenForNewOrders() =>
      socket.listenNewOrders().map((m) => m.toEntity());

  @override
  Stream<OrderEntity> listenForStatusUpdates() =>
      socket.listenStatusUpdates().map((m) => m.toEntity());

  @override
  Stream<Map<String, dynamic>> listenForCancelled() =>
      socket.listenCancelled();
}
