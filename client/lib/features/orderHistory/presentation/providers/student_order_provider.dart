import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:client/core/api_endpoints.dart';
import 'package:client/features/admin/data/models/order_model.dart';
import 'package:client/features/admin/domain/entities/order_entity.dart';
import 'package:client/features/orderHistory/data/datasources/socket_student_order_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../auth/data/datasource/hive_session_storage.dart';

final studentOrdersStreamProvider =
    StreamProvider<List<OrderEntity>>((ref) async* {
  log("🚀 studentOrdersStreamProvider STARTED");

  final session = await HiveSessionStorage().getSession();

  Map<String, dynamic>? userData;
  try {
    dynamic firstDecode = jsonDecode(session!.user);
    if (firstDecode is String) {
      firstDecode = jsonDecode(firstDecode);
    }
    if (firstDecode is Map<String, dynamic>) {
      userData = firstDecode;
    }
  } catch (e) {
    log("❌ JSON decode failed: $e");
  }


  final userId = userData?['id'];

  if (userId == null) {
    log("❌ user null — returning empty");
    yield [];
    return;
  }

  final past = await fetchUserOrdersFromAPI(userId);
  log("✅ Past Orders: ${past.length}");
  yield [...past];

  final socket = StudentOrderSocketDataSource();
  socket.connect(userId);

  socket.listenUpdates().listen((updatedModel) {
    final updated = updatedModel.toEntity();
    log("🔥 Real-time update: ${updated.id}");
    ref.state = AsyncData(past.map((o) => o.id == updated.id ? updated : o).toList());
  });

  ref.onDispose(() {
    log("🛑 Provider disposed — socket closed");
    socket.disconnect();
  });
});



Future<List<OrderEntity>> fetchUserOrdersFromAPI(String userId) async {
  final session = await HiveSessionStorage().getSession();
  final token = session?.token ?? "";

  final url = Uri.parse("${ApiConfig.baseUrl}/orders/user/$userId");
  log("🌍 Fetching orders from $url");

  final res = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode != 200) return [];

  final data = jsonDecode(res.body) as List;
  return data.map((e) => OrderModel.fromJson(e).toEntity()).toList();
}
