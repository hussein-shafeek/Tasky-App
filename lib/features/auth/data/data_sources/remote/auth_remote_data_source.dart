import 'package:dartz/dartz.dart';
import 'package:tasky_app/features/auth/data/models/auth_response.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest loginRequest);

  Future<AuthResponse> register(RegisterRequest registerRequest);

  Future<Unit> logout();
}
