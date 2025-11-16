class TaskModel {
  final String id;
  final String title;
  final String description;
  final String endDate;
  final String status;
  final String priority;
  final double progress;
  final String qrImage;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.endDate,
    required this.status,
    required this.priority,
    required this.progress,
    required this.qrImage,
  });
}
