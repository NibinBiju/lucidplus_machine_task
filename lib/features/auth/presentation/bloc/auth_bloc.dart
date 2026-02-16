import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/auth/domain/usecase/login_usecase.dart';
import 'package:lucidplus_machine_task/features/auth/domain/usecase/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;

  AuthBloc({required this.loginUseCase, required this.signUpUseCase})
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_logOutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(authModel: event.authModel);

    result.fold(
      (error) => emit(AuthError(message: error.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signUpUseCase(authModel: event.authModel);

    result.fold((error) => emit(AuthError(message: error.message)), (
      userCredential,
    ) {
      emit(AuthAccountCreated(message: "Account created successfully"));
      emit(AuthInitial());
    });
  }

  Future<void> _logOutRequested(
    LogoutRequested logOutRequestedEvent,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLogout());
  }
}
