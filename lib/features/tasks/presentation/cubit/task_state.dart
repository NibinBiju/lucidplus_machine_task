part of 'task_cubit.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final bool hasMore;

  TaskLoaded({required this.tasks, required this.hasMore});
}

class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}
