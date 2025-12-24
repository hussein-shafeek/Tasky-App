import 'package:equatable/equatable.dart';
import 'package:tasky_app/features/auth/data/auth_tokens.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthTokens auth;

  const AuthAuthenticated(this.auth);

  @override
  List<Object?> get props => [auth];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthValidationError extends AuthState {
  final String? phoneError;
  final String? passwordError;

  const AuthValidationError({this.phoneError, this.passwordError});

  @override
  List<Object?> get props => [phoneError, passwordError];
}

//new
// import 'package:tasky_app/features/auth/data/auth_response.dart';

// sealed class AuthState {
//   const AuthState();
// }

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class AuthAuthenticated extends AuthState {
//   final AuthResponse user;
//   const AuthAuthenticated(this.user);
// }

// class AuthUnauthenticated extends AuthState {}

// class AuthError extends AuthState {
//   final String message;
//   const AuthError(this.message);
// }
