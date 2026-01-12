import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/domain/entities/user_entity.dart';
import 'package:tasky_app/features/auth/domain/repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(LoginRequest loginRequest) =>
      authRepo.login(loginRequest);
}
