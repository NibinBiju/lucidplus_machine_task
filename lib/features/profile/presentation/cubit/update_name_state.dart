part of 'update_name_cubit.dart';

@immutable
sealed class UpdateNameState {}

final class UpdateNameInitial extends UpdateNameState {}

final class UpdateNameLoading extends UpdateNameState {}

final class UpdateNameFailed extends UpdateNameState {
  final String message;

  UpdateNameFailed({required this.message});
}

final class UpdateNameSuccess extends UpdateNameState {
  final String message;

  UpdateNameSuccess({required this.message});
}
