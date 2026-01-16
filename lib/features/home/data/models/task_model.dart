import 'package:tasky_app/features/home/domain/entities/tasks_entity.dart';
import 'package:tasky_app/features/home/domain/enums/priority.dart';
import 'package:tasky_app/features/home/domain/value_objects/status.dart';

class TaskModel {
  final String id;
  final String? image;
  final String title;
  final String desc;
  final Priority priority;
  final Status status;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
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

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["_id"],
      image: json['image'],

      title: json["title"] ?? "",
      desc: json["desc"] ?? "",
      priority: Priority.fromName(json["priority"]?.toString()),
      status: Status.fromName(json["status"]?.toString()),
      user: json["user"] ?? "",
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "desc": desc,
      "priority": priority.name,
      "status": status.value,
      "user": user,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  // TasksEntity get toEntity => TasksEntity(
  //   id: id,
  //   image: image,
  //   title: title,
  //   desc: desc,
  //   priority: priority,
  //   status: status,
  //   user: user,
  //   createdAt: createdAt,
  //   updatedAt: updatedAt,
  // );
}
