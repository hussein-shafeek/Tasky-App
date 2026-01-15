import 'package:tasky_app/features/home/data/models/task_model.dart';

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getTasks({int page = 1});
  Future<TaskModel> getTaskById(String id);
}
