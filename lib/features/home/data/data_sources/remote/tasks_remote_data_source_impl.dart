import 'dart:io';

import 'package:dio/dio.dart';
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
    await apiConsumer.put(
      path: EndPoints.updateTask(id),
      body: task.toUpdateBody(),
    );
  }

  // -------------------add task-------------------
  @override
  Future<TaskModel> addTask(TaskModel task) async {
    final response = await apiConsumer.post(
      path: EndPoints.addTask,
      body: task.toAddBody(),
    );
    return TaskModel.fromJson(response);
  }

  @override
  Future<String> uploadImage(File image) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split(RegExp(r'[/\\]')).last,
      ),
    });

    final response = await apiConsumer.post(
      path: EndPoints.uploadImage,
      body: formData,
    );

    return response['image'];
  }

  //   @override
  //   Future<TaskModel> updateTask({
  //     required String id,
  //     required Map<String, dynamic> body,
  //   }) async {
  //     final response = await apiConsumer.put(
  //       path: EndPoints.updateTask(id),
  //       body: body,
  //     );

  //     return TaskModel.fromJson(response);
  //   }
}
