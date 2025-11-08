import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:client/core/api_endpoints.dart';
import 'package:client/features/admin/data/models/order_model.dart';
import 'package:client/features/admin/domain/entities/order_entity.dart';
import 'package:client/features/orderHistory/data/datasources/socket_student_order_datasource.dart';
import 'package:client/features/orderHistory/data/repository/student_order_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../auth/data/datasource/hive_session_storage.dart';


final studentOrdersStreamProvider =
    StreamProvider< List<OrderEntity> >((ref) async* {

  final session = await HiveSessionStorage().getSession();
  final user = session?.safeDecodeUser();
  final userId = user?['id'];
  log('userId: $userId');


  if (userId == null) {
    yield [];
    return;
  }

  final socket = StudentOrderSocketDataSource();
  final repo = StudentOrderRepositoryImpl(socket);

  List<OrderEntity> orders = [];

  final past = await fetchUserOrdersFromAPI(userId);
  orders = [...past];
  yield orders;

  socket.connect(userId);

  repo.onOrderUpdated().listen((updated) {
    orders = orders.map((o) => o.id == updated.id ? updated : o).toList();
    ref.state = AsyncData(orders);
  });

  ref.onDispose(() => socket.disconnect());
});

Future<List<OrderEntity>> fetchUserOrdersFromAPI(String userId) async {
  final session = await HiveSessionStorage().getSession();
  final token = session?.token ?? "";
  final url = Uri.parse("${ApiConfig.baseUrl}/orders/user/$userId");
  final res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },);

  if (res.statusCode != 200) return [];

  final data = jsonDecode(res.body) as List;
  return data.map((e) => OrderModel.fromJson(e).toEntity()).toList();
}
