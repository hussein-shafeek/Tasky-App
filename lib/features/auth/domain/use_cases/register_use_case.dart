import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'package:tasky_app/features/auth/domain/entities/user_entity.dart';
import 'package:tasky_app/features/auth/domain/repositories/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo authRepo;

  RegisterUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(RegisterRequest registerRequest) =>
      authRepo.register(registerRequest);
}
