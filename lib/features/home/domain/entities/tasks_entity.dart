import 'package:tasky_app/features/home/domain/enums/priority.dart';
import 'package:tasky_app/features/home/domain/value_objects/status.dart';

class TasksEntity {
  final String id;
  final String? image;
  final String title;
  final String desc;
  final Priority priority;
  final Status status;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TasksEntity({
    required this.id,
    this.image,
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });
}
