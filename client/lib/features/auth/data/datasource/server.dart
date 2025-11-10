import 'dart:convert';
import 'package:client/core/api_endpoints.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:client/features/auth/data/models/session_model.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ServerData {
  final http.Client client;
  ServerData({required this.client});
  Future<SessionModel> login(String email, String password) async {
    try {
      final res = await client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.login}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        log(res.body);
        final data = SessionModel.fromJson(json.decode(res.body));
        await HiveSessionStorage().saveSession(
          SessionModel(token: data.token, user: jsonEncode(data.user)),
        );
        return data;
      } else if (res.statusCode == 400) {
        throw InvalidCredentialsFailure();
      } else {
        final error = json.decode(res.body);
        log(error.toString());
        throw ServerFailure(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      log('Error: ${e.toString()}');
      throw NetworkFailure();
    }
  }

  Future<SessionModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? adminSecret,
  }) async {
    try {

      final body = {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      };

      if (adminSecret != null && role == "admin") {
        body['adminSecret'] = adminSecret;
      }
      final res = await client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.signup}'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(body)
        ) ;
        
      if (res.statusCode == 201) {
        final data = SessionModel.fromJson(json.decode(res.body));
        await HiveSessionStorage().saveSession(
          SessionModel(token: data.token, user: jsonEncode(data.user)),
        );
        return data;
      } else if (res.statusCode == 400)
        throw InvalidCredentialsFailure();
      else {
        final error = json.decode(res.body);
        throw ServerFailure(error['error'] ?? 'Register failed');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      log(e.toString());
      throw NetworkFailure();
    }
  }

  Future<SessionModel> getCurrentUser(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiEndpoints.login}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SessionModel.fromJson(data['user']);
      } else if (response.statusCode == 401) {
        throw UnauthorizedFailure();
      } else {
        throw ServerFailure('Failed to get user');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw NetworkFailure();
    }
  }
}
