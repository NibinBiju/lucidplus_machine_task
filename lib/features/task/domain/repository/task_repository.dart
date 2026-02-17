import 'package:lucidplus_machine_task/features/task/domain/entity/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> fetchTasks({
    required String userId,
    required int skip,
    required int limit,
  });
}
