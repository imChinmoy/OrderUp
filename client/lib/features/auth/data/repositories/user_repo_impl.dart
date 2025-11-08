import 'package:client/features/auth/data/datasource/server.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:client/features/auth/data/models/session_model.dart';
import 'package:client/features/auth/domain/entities/session_entity.dart';
import 'package:client/features/auth/domain/repository/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final ServerData _serverData;
  final HiveSessionStorage _sessionStorage;
  String? _token;

  UserRepoImpl(this._serverData, this._sessionStorage);

  @override
  Future<SessionEntity> login(String email, String password) async {
    final userModel = await _serverData.login(email, password);
    final session = SessionModel(token: userModel.token, user: userModel.user);
    
    // Save session to Hive
    await _sessionStorage.saveSession(session);
    
    _token = session.token;
    return session.toSessionEntity();
  }

  @override
  Future<SessionEntity> register(
    String email,
    String password,
    String name,
    String role,
  ) async {
    final userModel = await _serverData.register(
      email: email,
      password: password,
      name: name,
      role: role,
    );
    final session = SessionModel(token: userModel.token, user: userModel.user);
    
    // Save session to Hive
    await _sessionStorage.saveSession(session);
    
    _token = session.token;
    return session.toSessionEntity();
  }

  @override
  String? getToken() => _token;

  @override
  Future<bool> isAuthenticated() async {
    if (_token == null) return false;
    try {
      await _serverData.getCurrentUser(_token!);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    // Clear in-memory token
    _token = null;
    
    // Clear Hive session storage
    await _sessionStorage.clearSession();
  }
}