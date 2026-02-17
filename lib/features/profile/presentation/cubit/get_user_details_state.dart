part of 'get_user_details_cubit.dart';

@immutable
sealed class GetUserDetailsState {}

final class GetUserDetailsInitial extends GetUserDetailsState {}

final class GetUserDetailsLoading extends GetUserDetailsState {}

final class GetUserDetailsFailed extends GetUserDetailsState {
  final String message;

  GetUserDetailsFailed({required this.message});
}

final class GetUserDetailsSuccess extends GetUserDetailsState {
  final UserModel userModel;

  GetUserDetailsSuccess({required this.userModel});
}
