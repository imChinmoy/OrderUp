import 'package:client/features/auth/domain/entities/session_entity.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';
import 'package:client/features/auth/domain/repository/user_repo.dart';
import 'package:email_validator/email_validator.dart';

class RegisterUsecase {

  final UserRepo _userRepo;
  RegisterUsecase(this._userRepo);

  Future<SessionEntity> call({  required String email, required String password, required String name, required String role, String? adminSecret}) async {
    if(email.isEmpty || password.isEmpty || role.isEmpty || name.isEmpty){
      throw AuthFailure('Email and Password is required');
    }
    if (role == "admin" && (adminSecret == null || adminSecret.isEmpty)) {
    throw AuthFailure("Admin secret key required");
    }

    if(EmailValidator.validate(email)==false){
      throw AuthFailure('Email is not valid');
    }
    if(password.length<6){
      throw AuthFailure('Password must be at least 6 characters');
    }
    return await _userRepo.register(email, password, name, role, adminSecret: adminSecret,);
  }
  
}