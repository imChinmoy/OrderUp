import 'package:client/features/auth/data/datasource/server.dart';
import 'package:client/features/auth/data/datasource/hive_session_storage.dart';
import 'package:client/features/auth/data/repositories/user_repo_impl.dart';
import 'package:client/features/auth/domain/usecases/login_usecase.dart';
import 'package:client/features/auth/domain/usecases/register_usecase.dart';
import 'package:client/features/auth/domain/usecases/logout_usecase.dart';
import 'package:client/features/auth/domain/entities/session_entity.dart';
import 'package:client/features/profile/features/providers/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Session Storage Provider
final sessionStorageProvider = Provider<HiveSessionStorage>((ref) {
  return HiveSessionStorage();
});

// Login Provider
final loginProvider = FutureProvider.family<SessionEntity, Map<String, String>>(
  (ref, params) async {
    final client = http.Client();
    try {
      final service = ServerData(client: client);
      final sessionStorage = ref.read(sessionStorageProvider);
      final repo = UserRepoImpl(service, sessionStorage);
      final usecase = LoginUsecase(repo);

      return await usecase(
        email: params['email']!,
        password: params['password']!,
      );
    } finally {
      client.close();
    }
  },
);

// Register Provider
final registerProvider =
    FutureProvider.family<SessionEntity, Map<String, String>>((
      ref,
      params,
    ) async {
      final client = http.Client();
      try {
        final service = ServerData(client: client);
        final sessionStorage = ref.read(sessionStorageProvider);
        final repo = UserRepoImpl(service, sessionStorage);
        final usecase = RegisterUsecase(repo);

        return await usecase(
          email: params['email']!,
          password: params['password']!,
          name: params['name']!,
          role: params['role']!,
        );
      } finally {
        client.close();
      }
    });

// Logout Provider
final logoutProvider = FutureProvider<void>((ref) async {
  final client = http.Client();
  try {
    final service = ServerData(client: client);
    final sessionStorage = ref.read(sessionStorageProvider);
    final repo = UserRepoImpl(service, sessionStorage);
    final usecase = LogoutUsecase(repo);

    await usecase();
  } finally {
    client.close();
  }
});

// Auth State Notifier (for managing logout state)
// Auth State Notifier (for managing logout state)
class AuthStateNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(const AsyncValue.data(true));

  Future<bool> logout() async {
    state = const AsyncValue.loading();

    try {
      final client = http.Client();
      final service = ServerData(client: client);
      final sessionStorage = ref.read(sessionStorageProvider);
      final repo = UserRepoImpl(service, sessionStorage);
      final usecase = LogoutUsecase(repo);

      await usecase();


      ref.invalidate(profileProvider);
      
      state = const AsyncValue.data(false); // User logged out
      client.close();
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<bool>>((ref) {
      return AuthStateNotifier(ref);
    });
