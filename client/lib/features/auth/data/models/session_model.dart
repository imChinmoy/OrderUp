import 'dart:convert';

import 'package:client/features/auth/domain/entities/session_entity.dart';
import 'package:hive/hive.dart';

part 'session_model.g.dart';
@HiveType(typeId: 0)
class SessionModel {

  @HiveField(0)
  final String token;
  
  @HiveField(1)
  final String user;

  SessionModel({required this.token, required this.user});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      token: json['token'],
      user: jsonEncode(json['user']),
    );
  }
  SessionEntity toSessionEntity() {
    return SessionEntity(token: token, user: user.toString());
  }

  safeDecodeUser() {}
}
