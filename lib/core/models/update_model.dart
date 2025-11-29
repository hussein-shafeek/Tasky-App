class UpdateTodoModel {
  final String image;
  final String title;
  final String desc;
  final String priority;
  final String status;
  final String user;

  UpdateTodoModel({
    required this.image,
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "desc": desc,
      "priority": priority,
      "status": status,
      "user": user,
    };
  }
}
