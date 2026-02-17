import 'package:dartz/dartz.dart';
import 'package:lucidplus_machine_task/features/task/domain/entity/task_entity.dart';
import 'package:lucidplus_machine_task/features/task/domain/repository/task_repository.dart';

class AddTaskUsecase {
  final TaskRepository repository;

  AddTaskUsecase(this.repository);
  Future<Either> call(String userId, TaskEntity task) async {
    return await repository.addTask(userId, task);
  }
}
