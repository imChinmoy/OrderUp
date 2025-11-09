import 'dart:convert';
import 'package:client/core/api_endpoints.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

class MenuRemoteDataSource {
  Future<List<MenuModel>> getAllItems() async {
    final token = (await HiveSessionStorage().getSession())?.token ?? "";
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/items"),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(res.body);
    return (data as List).map((e) => MenuModel.fromJson(e)).toList();
  }

  Future<MenuModel> addItem(Map<String, dynamic> body) async {
    final token = (await HiveSessionStorage().getSession())?.token ?? "";
    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/items"),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonEncode(body),
    );

    return MenuModel.fromJson(jsonDecode(res.body));
  }

  Future<MenuModel> updateStock(String id, bool newAvailable) async {
    final token = (await HiveSessionStorage().getSession())?.token ?? "";
    final res = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/items/$id"),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonEncode({"isAvailable": newAvailable}),
    );

    return MenuModel.fromJson(jsonDecode(res.body));
  }

  Future<bool> deleteItem(String id) async {
    final token = (await HiveSessionStorage().getSession())?.token ?? "";
    final res = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/items/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    return res.statusCode == 200;
  }
}
  