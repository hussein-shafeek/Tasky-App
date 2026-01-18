import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/profile/domain/entities/profile_entity.dart';
import 'package:tasky_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase({required this.repository});

  Future<Either<Failure, ProfileEntity>> call() {
    return repository.getProfile();
  }
}
