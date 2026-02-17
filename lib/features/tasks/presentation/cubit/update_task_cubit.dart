import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/repository/task_repository.dart';

part 'update_task_state.dart';

class UpdateTaskCubit extends Cubit<UpdateTaskState> {
  final TaskRepository repository;
  final String userId;

  UpdateTaskCubit({required this.repository, required this.userId})
    : super(UpdateTaskInitial());

  Future<void> updateTask(TaskEntity task) async {
    try {
      emit(UpdateTaskLoading());

      await repository.updateTask(userId, task.id ?? 0, {
        'is_completed': task.isCompleted,
        'priority': task.priority,
      });

      emit(UpdateTaskSuccess());
    } catch (e) {
      emit(UpdateTaskError(message: e.toString()));
    }
  }
}
