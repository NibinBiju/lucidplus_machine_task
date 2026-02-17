import 'package:dartz/dartz.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> fetchTasks({
    required String userId,
    required int skip,
    required int limit,
  });

  Future<Either> addTask(String userId, TaskEntity task);

  Future<Either> updateTask(String userId, int taskId, Map<String, dynamic> data);
}
