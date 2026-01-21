import 'package:tasky_app/core/api/api_consumer.dart';
import 'package:tasky_app/core/api/end_points.dart';
import 'package:tasky_app/features/home/data/data_sources/remote/tasks_remote_data_source.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final ApiConsumer apiConsumer;

  TasksRemoteDataSourceImpl({required this.apiConsumer});

  //pagination
  @override
  Future<List<TaskModel>> getTasks({int page = 1}) async {
    final response = await apiConsumer.get(
      path: EndPoints.getTasks,
      queryParameters: {'page': page},
    );
    return (response as List).map((e) => TaskModel.fromJson(e)).toList();
  }

  // -------------------get task by id-------------------
  @override
  Future<TaskModel> getTaskById(String id) async {
    final response = await apiConsumer.get(path: EndPoints.getTaskById(id));
    return TaskModel.fromJson(response);
  }

  // -------------------delete task-------------------
  @override
  Future<void> deleteTask(String id) async {
    await apiConsumer.delete(path: EndPoints.deleteTask(id));
  }
  // -------------------update task-------------------
  @override
  Future<void> updateTask(String id, TaskModel task) async {
    await apiConsumer.put(path: EndPoints.updateTask(id), body: task.toUpdateBody());
  }
  // -------------------add task-------------------
  @override
  Future<void> addTask(TaskModel task) async {
    await apiConsumer.post(path: EndPoints.addTask, body: task.addTask());
  }
}
