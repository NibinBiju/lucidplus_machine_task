import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';

@HiveType(typeId: 0)
class TaskModel extends TaskEntity {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String priority;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final DateTime createdDate;

  @HiveField(6)
  final int? id;

  TaskModel({
    required this.title,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
    required this.createdDate,
    this.id,
  }) : super(
         title: title,
         category: category,
         priority: priority,
         dueDate: dueDate,
         isCompleted: isCompleted,
         createdDate: createdDate,
         id: id,
       );

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

  TaskModel copyWith({
    String? title,
    String? category,
    String? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdDate,
    int? id,
  }) {
    return TaskModel(
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdDate: createdDate ?? this.createdDate,
      id: id ?? this.id,
    );
  }
}
