/// Result of an auth operation (login, signup).
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  const AuthSuccess();
}

class AuthFailure extends AuthResult {
  final String message;

  const AuthFailure(this.message);
}
