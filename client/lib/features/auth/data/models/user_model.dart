import 'package:client/features/auth/domain/entities/user_entity.dart';
class UserModel {
  final String id;
  final String email;
  final String name;
  final String password;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'],
      password: json['password'],
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'role': role,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      password: password,
      role: UserRole.fromString(role),
    );
  }
}
