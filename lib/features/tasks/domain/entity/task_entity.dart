class TaskEntity {
  final int? id;
  final String title;
  final bool isCompleted;
  final DateTime dueDate;
  final String priority;
  final String category;
  final DateTime createdDate;

  TaskEntity({
    required this.title,
    required this.isCompleted,
    required this.dueDate,
    required this.priority,
    required this.category,
    DateTime? createdDate,
    this.id,
  }) : createdDate = createdDate ?? DateTime.now();
}
