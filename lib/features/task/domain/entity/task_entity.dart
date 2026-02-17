class TaskEntity {
  final String title;
  final String category;
  final String priority;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime createdDate;

  TaskEntity({
    required this.title,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
    required this.createdDate,
  });
}
