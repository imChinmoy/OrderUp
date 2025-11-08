import 'package:client/features/auth/domain/repository/user_repo.dart';

class LogoutUsecase {
  final UserRepo _repo;

  LogoutUsecase(this._repo);

  Future<void> call() async {
    await _repo.logout();
  }
}