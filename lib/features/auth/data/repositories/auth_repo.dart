import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/auth/data/models/auth_response.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthResponse>> register(
    RegisterRequest registerRequest,
  );

  Future<Either<Failure, AuthResponse>> login(LoginRequest loginRequest);

  Future<Either<Failure, Unit>> logout();
}
