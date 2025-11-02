import 'package:client/features/auth/data/models/user_model.dart';
import 'package:client/features/auth/domain/entities/session_entity.dart';

class SessionModel {
  final String token;
  final UserModel user;
  SessionModel({required this.token, required this.user});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }
  SessionEntity toSessionEntity() {
    return SessionEntity(token: token, user: user.toString());
  }
}
