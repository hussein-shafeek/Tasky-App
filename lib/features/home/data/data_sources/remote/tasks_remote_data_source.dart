import 'dart:io';

import 'package:tasky_app/features/home/data/models/task_model.dart';

abstract class TasksRemoteDataSource {
  // -------------------get tasks-------------------
  Future<List<TaskModel>> getTasks({int page = 1});
  // -------------------get task by id-------------------
  Future<TaskModel> getTaskById(String id);
  // -------------------delete task-------------------
  Future<void> deleteTask(String id);
  // -------------------update task-------------------
  Future<void> updateTask(String id, TaskModel task);

  Future<String> uploadImage(File image);

  // Future<TaskModel> updateTask({
  //   required String id,
  //   required Map<String, dynamic> body,
  // });
}
