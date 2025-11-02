import 'package:client/features/auth/domain/entities/session_entity.dart';

abstract class UserRepo {

  Future<SessionEntity> login(String email, String password);
  Future<SessionEntity> register(String email, String password, String name, String role);
  Future<bool> isAuthenticated();
  Future<void> logout();

  String? getToken();
}