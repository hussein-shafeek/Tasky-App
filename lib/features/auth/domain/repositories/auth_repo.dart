import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'package:tasky_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> register(RegisterRequest registerRequest);

  Future<Either<Failure, UserEntity>> login(LoginRequest loginRequest);

  Future<Either<Failure, Unit>> logout();
}
