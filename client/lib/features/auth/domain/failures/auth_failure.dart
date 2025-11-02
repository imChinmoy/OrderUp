class AuthFailure {
  final String message;
  AuthFailure(this.message);
}

class ServerFailure extends AuthFailure {
  ServerFailure(super.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  InvalidCredentialsFailure() : super('Invalid email or password');
}

class NetworkFailure extends AuthFailure {
  NetworkFailure() : super('Network connection failed');
}

class UnauthorizedFailure extends AuthFailure {
  UnauthorizedFailure() : super('Unauthorized access');
}
