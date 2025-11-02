import 'package:client/features/auth/domain/repository/user_repo.dart';

class LogoutUsecase {
  final UserRepo _userRepo;
  LogoutUsecase(this._userRepo);
  Future<void> call() async => await _userRepo.logout();
}