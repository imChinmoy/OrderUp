import 'dart:convert';
import 'dart:developer';

import 'package:client/core/api_endpoints.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final verifyPickupProvider = FutureProvider.family<bool, String>((ref, qr) async {
  final token = (await HiveSessionStorage().getSession())?.token ?? '';
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
  final url = Uri.parse('${ApiConfig.baseUrl}/orders/verifyQR');

  final res = await http.post(
    url,
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    body: jsonEncode({'qr': qr, 'userId': userId}),
  );

  if (res.statusCode != 200) return false;
  final body = jsonDecode(res.body);
  return body['success'] == true;
});
