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
  // --------- copyWith method ----------
  TaskModel copyWith({
    String? id,
    String? image,
    String? title,
    String? desc,
    Priority? priority,
    Status? status,
    String? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
      "id": id,
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

  // update task (edit task)
  Map<String, dynamic> toUpdateBody() {
    return {
      "image": _getRawImageName(image),
      "title": title,
      "desc": desc,
      "priority": priority.name,
      "status": status.value,
      "user": user,
    };
  }

  // add task
  Map<String, dynamic> addTask() {
    return {
      "image": _getRawImageName(image),
      "title": title,
      "desc": desc,
      "priority": priority.name,
      "dueDate": createdAt.toIso8601String(),
    };
  }

  String? get fullImageUrl {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) return image;
    return 'https://todo.iraqsapp.com/images/$image';
  }

  static String? _getRawImageName(String? img) {
    if (img == null) return null;
    if (img.contains('/')) {
      return img.split('/').last;
    }
    return img;
  }
}
