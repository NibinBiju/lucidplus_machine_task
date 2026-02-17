import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.title,
    required super.category,
    required super.priority,
    required super.dueDate,
    required super.isCompleted,
    required super.createdDate,
    super.id,
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
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'is_completed': isCompleted,
      'due_date': dueDate.toIso8601String(),
      'priority': priority,
      'category': category,
      'created_at': createdDate.toIso8601String(),
      'id': id,
    };
  }
}
