import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';
import 'package:lucidplus_machine_task/features/tasks/presentation/cubit/add_task_state.dart';
import '../../domain/repository/task_repository.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TaskRepository repository;
  final String userId;

  AddTaskCubit({required this.repository, required this.userId})
    : super(AddTaskInitial());

  Future<void> addTask(TaskEntity task) async {
    emit(AddTaskLoading());
    try {
      await repository.addTask(userId, task);
      emit(AddTaskSuccess(successMessage: "Added Successfully"));
    } catch (e) {
      emit(AddTaskFailed(errorMessage: e.toString()));
    }
  }
}
