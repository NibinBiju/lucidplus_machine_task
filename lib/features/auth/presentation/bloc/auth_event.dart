import '../../data/model/auth_model.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final AuthModel authModel;

  LoginRequested({required this.authModel});
}

class SignUpRequested extends AuthEvent {
  final AuthModel authModel;

  SignUpRequested({required this.authModel});
}

class LogoutRequested extends AuthEvent {}
