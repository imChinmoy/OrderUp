class UserEntity {
  final String id;
  final String email;
  final String name;
  final  String password;
  final UserRole role;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.password
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isStudent => role == UserRole.student;
}

enum UserRole {
  admin,
  student;

  String get value => name;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value.toLowerCase(),
      orElse: () => UserRole.student,
    );
  }
}
