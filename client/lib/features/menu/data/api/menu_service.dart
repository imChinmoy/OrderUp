import 'dart:convert';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:http/http.dart' as http;
import '../models/menu_item_model.dart';
import 'package:client/core/api_endpoints.dart';

abstract class MenuService {
  Future<List<MenuItemModel>> fetchMenuItems();
  Future<List<MenuItemModel>> fetchTrendingMenuItems();
  Future<List<MenuItemModel>> fetchAvailableMenuItems();
}

class MenuServiceImpl implements MenuService {
  final http.Client client;

  MenuServiceImpl(this.client);

  @override
  Future<List<MenuItemModel>> fetchMenuItems() async {
    final session = await HiveSessionStorage().getSession();
    final token = session?.token ?? "";

    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.menu}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => MenuItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

@override
Future<List<MenuItemModel>> fetchTrendingMenuItems() async {
  final session = await HiveSessionStorage().getSession();
  final token = session?.token ?? "";

  final response = await client.get(
    Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.trending}'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => MenuItemModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load trending items');
  }
}
@override
Future<List<MenuItemModel>> fetchAvailableMenuItems() async {
  final session = await HiveSessionStorage().getSession();
  final token = session?.token ?? "";

  final response = await client.get(
    Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.availableItems}'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => MenuItemModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load trending items');
  }
}

}
