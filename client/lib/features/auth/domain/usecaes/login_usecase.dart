import 'package:client/features/auth/domain/entities/session_entity.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';
import 'package:client/features/auth/domain/repository/user_repo.dart';

class LoginUsecase {

  final UserRepo _userRepo;
  LoginUsecase(this._userRepo);

  Future<SessionEntity> call({  required String email, required String password }) async {
    if(email.isEmpty || password.isEmpty){
      throw AuthFailure('Email and Password is required');
    }
    return _userRepo.login(email, password);
  }
  
}