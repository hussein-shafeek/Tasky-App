import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/entities/tasks_entity.dart';

extension TaskMapper on TaskModel {
  TasksEntity get toEntity => TasksEntity(
    id: id,
    image: image,
    title: title,
    desc: desc,
    priority: priority,
    status: status,
    user: user,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
