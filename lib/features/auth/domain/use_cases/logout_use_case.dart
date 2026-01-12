import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/auth/domain/repositories/auth_repo.dart';

class LogoutUseCase {
  final AuthRepo authRepo;

  LogoutUseCase({required this.authRepo});

  Future<Either<Failure, Unit>> call() => authRepo.logout();
}
