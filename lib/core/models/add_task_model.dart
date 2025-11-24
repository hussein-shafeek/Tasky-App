class CreateTodoModel {
  final String image;
  final String title;
  final String desc;
  final String priority; // low, medium, high
  final String dueDate; // "2024-05-15"

  CreateTodoModel({
    required this.image,
    required this.title,
    required this.desc,
    required this.priority,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "desc": desc,
      "priority": priority,
      "dueDate": dueDate,
    };
  }
}
