import 'package:lucidplus_machine_task/features/task/domain/entity/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.title,
    required super.category,
    required super.priority,
    required super.dueDate,
    required super.isCompleted,
    required super.createdDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      priority: json['priority'] ?? 'Low',
      category: json['category'] ?? 'General',
      dueDate: DateTime.tryParse(json['due_date'] ?? '') ?? DateTime.now(),
      createdDate:
          DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
