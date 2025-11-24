class TaskModel {
  final String id;
  final String? image;
  final String title;
  final String desc;
  final String priority; // low / medium / high
  final String status; // waiting / inprogress / finished
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
      image: json['image'] != null
          ? "https://todo.iraqsapp.com/images/${json['image']}"
          : null,

      title: json["title"],
      desc: json["desc"],
      priority: json["priority"],
      status: json["status"],
      user: json["user"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "desc": desc,
      "priority": priority,
      "status": status,
      "user": user,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
