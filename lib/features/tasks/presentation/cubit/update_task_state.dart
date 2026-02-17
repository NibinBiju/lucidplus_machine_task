part of 'update_task_cubit.dart';

abstract class UpdateTaskState {}

class UpdateTaskInitial extends UpdateTaskState {}

class UpdateTaskLoading extends UpdateTaskState {}

class UpdateTaskSuccess extends UpdateTaskState {}

class UpdateTaskError extends UpdateTaskState {
  final String message;
  UpdateTaskError({required this.message});
}
