import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
}
