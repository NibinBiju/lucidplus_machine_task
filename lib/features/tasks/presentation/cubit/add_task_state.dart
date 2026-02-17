import 'package:flutter/material.dart';

@immutable
sealed class AddTaskState {}

final class AddTaskInitial extends AddTaskState {}

final class AddTaskLoading extends AddTaskState {}

final class AddTaskSuccess extends AddTaskState {
  final String successMessage;

  AddTaskSuccess({required this.successMessage});
}

final class AddTaskFailed extends AddTaskState {
  final String errorMessage;

  AddTaskFailed({required this.errorMessage});
}
