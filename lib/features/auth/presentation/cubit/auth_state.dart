import 'package:equatable/equatable.dart';
//import 'package:tasky_app/features/auth/data/models/auth_tokens.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object?> get props => [];
}

class RegisterLoading extends AuthState {
  const RegisterLoading();
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends AuthState {
  const RegisterSuccess();
  @override
  List<Object?> get props => [];
}

class RegisterError extends AuthState {
  final String message;
  const RegisterError(this.message);
  @override
  List<Object?> get props => [message];
}

class LoginLoading extends AuthState {
  const LoginLoading();
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends AuthState {
  const LoginSuccess();
  @override
  List<Object?> get props => [];
}

class LoginError extends AuthState {
  final String message;
  const LoginError(this.message);
  @override
  List<Object?> get props => [message];
}

class LogoutLoading extends AuthState {
  const LogoutLoading();
  @override
  List<Object?> get props => [];
}

class LogoutSuccess extends AuthState {
  const LogoutSuccess();
  @override
  List<Object?> get props => [];
}

class LogoutError extends AuthState {
  final String message;
  const LogoutError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
  @override
  List<Object?> get props => [];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
  @override
  List<Object?> get props => [];
}






// class AuthLoading extends AuthState {
//   const AuthLoading();
//   @override
//   List<Object?> get props => [];
// }

// class AuthAuthenticated extends AuthState {
//   final AuthTokens auth;

//   const AuthAuthenticated(this.auth);

//   @override
//   List<Object?> get props => [auth];
// }

// class AuthUnauthenticated extends AuthState {
//   const AuthUnauthenticated();
//   @override
//   List<Object?> get props => [];
// }

// class AuthError extends AuthState {
//   final String message;
//   const AuthError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class AuthValidationError extends AuthState {
//   final String? phoneError;
//   final String? passwordError;

//   const AuthValidationError({this.phoneError, this.passwordError});

//   @override
//   List<Object?> get props => [phoneError, passwordError];


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
