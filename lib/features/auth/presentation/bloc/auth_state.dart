import '../../data/model/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated({required this.user});
}

class AuthAccountCreated extends AuthState {
  final String message;

  AuthAccountCreated({required this.message});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthLogout extends AuthState {}
