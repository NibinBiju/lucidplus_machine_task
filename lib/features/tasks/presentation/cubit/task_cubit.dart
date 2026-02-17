import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/tasks/domain/entity/task_entity.dart';
import '../../domain/repository/task_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository;
  final String userId;

  TaskCubit({required this.repository, required this.userId})
    : super(TaskInitial());

  int skip = 0;
  final int limit = 10;
  bool isFetching = false;
  List<TaskEntity> tasks = [];

  Future<void> fetchTasks({bool refresh = false}) async {
    if (isFetching) return;
    isFetching = true;

    if (refresh) {
      skip = 0;
      tasks.clear();
      emit(TaskLoading());
    }

    try {
      final newTasks = await repository.fetchTasks(
        userId: userId,
        skip: skip,
        limit: limit,
      );

      tasks.addAll(newTasks);
      skip += limit;

      emit(TaskLoaded(tasks: tasks, hasMore: newTasks.length == limit));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  void searchTasks(String query) async {
    if (query.isEmpty) {
      skip = 0;
      tasks.clear();
      tasks.clear();
      await fetchTasks(refresh: true);
      return;
    }

    tasks = tasks
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(TaskLoaded(tasks: tasks, hasMore: tasks.length < tasks.length));
  }
}
