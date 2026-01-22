import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import '../repositories/tasks_repository.dart';

class UploadImageUseCase {
  final TasksRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<Failure, String>> call(File image) async {
    return await repository.uploadImage(image);
  }
}
