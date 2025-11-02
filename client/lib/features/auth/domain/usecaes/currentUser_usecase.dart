import 'package:client/features/auth/domain/repository/user_repo.dart';

class CurrentuserUsecase {
  final UserRepo _userRepo;
  CurrentuserUsecase(this._userRepo);
  Future<String?> call() async => await _userRepo.getToken();
}