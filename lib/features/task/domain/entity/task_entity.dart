class TaskEntity {
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
  }) : createdDate = createdDate ?? DateTime.now(); 
}
