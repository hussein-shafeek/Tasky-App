sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String? token;
  const AuthSuccess({this.token});
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
