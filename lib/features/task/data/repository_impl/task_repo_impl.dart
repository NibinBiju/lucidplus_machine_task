import 'package:lucidplus_machine_task/features/task/data/source/task_source.dart';
import 'package:lucidplus_machine_task/features/task/domain/entity/task_entity.dart';

import '../../domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TaskEntity>> fetchTasks({
    required String userId,
    required int skip,
    required int limit,
  }) async {
    return await remoteDataSource.getTasks(userId, skip, limit);
  }
}
