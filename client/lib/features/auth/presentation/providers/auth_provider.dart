import 'package:client/features/auth/data/api/server.dart';
import 'package:client/features/auth/data/repositories/user_repo_impl.dart';
import 'package:client/features/auth/domain/usecases/login_usecase.dart';
import 'package:client/features/auth/domain/usecases/register_usecase.dart';
import 'package:client/features/auth/domain/entities/session_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Login Provider
final loginProvider =
    FutureProvider.family<SessionEntity, Map<String, String>>((ref, params) async {
  final client = http.Client();
  try {
    final service = ServerData(client: client);
    final repo = UserRepoImpl(service);
    final usecase = LoginUsecase(repo);

    return await usecase(
      email: params['email']!,
      password: params['password']!,
    );
  } finally {
    client.close();
  }
});

// Register Provider
final registerProvider =
    FutureProvider.family<SessionEntity, Map<String, String>>((ref, params) async {
  final client = http.Client();
  try {
    final service = ServerData(client: client);
    final repo = UserRepoImpl(service);
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
