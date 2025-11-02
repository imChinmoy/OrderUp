class SessionEntity {
  final String token;
  final String? role;
  final String user;

  SessionEntity({required this.token, this.role, required this.user});
}
