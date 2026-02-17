import 'package:dartz/dartz.dart';
import 'package:lucidplus_machine_task/features/tasks/data/model/task_model.dart';
import 'package:lucidplus_machine_task/features/tasks/data/source/task_source.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';

import '../../domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteSource remoteSource;

  TaskRepositoryImpl(this.remoteSource);

  @override
  Future<List<TaskEntity>> fetchTasks({
    required String userId,
    required int skip,
    required int limit,
  }) async {
    return await remoteSource.getTasks(userId, skip, limit);
  }

  @override
  Future<Either<dynamic, dynamic>> addTask(
    String userId,
    TaskEntity task,
  ) async {
    final model = TaskModel(
      title: task.title,
      isCompleted: task.isCompleted,
      dueDate: task.dueDate,
      priority: task.priority,
      category: task.category,
      createdDate: task.createdDate,
    );
    var returnedData = await remoteSource.addTask(userId, model);

    return returnedData.fold(
      (error) {
        return Left("Failed");
      },
      (success) {
        return Right("Success");
      },
    );
  }

  @override
  Future<Either> updateTask(
    String userId,
    int taskId,
    Map<String, dynamic> data,
  ) async {
    return await remoteSource.updateTask(userId, taskId, data);
  }
}
