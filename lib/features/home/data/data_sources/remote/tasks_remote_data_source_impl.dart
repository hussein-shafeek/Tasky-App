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

  @override
  Future<TaskModel> getTaskById(String id) async {
    final response = await apiConsumer.get(path: EndPoints.getTaskById(id));
    return TaskModel.fromJson(response);
  }
}
