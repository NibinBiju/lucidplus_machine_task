import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:lucidplus_machine_task/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:lucidplus_machine_task/features/auth/data/source/auth_source.dart';
import 'package:lucidplus_machine_task/features/auth/domain/repository/auth_repository.dart';
import 'package:lucidplus_machine_task/features/auth/domain/usecase/login_usecase.dart';
import 'package:lucidplus_machine_task/features/auth/domain/usecase/signup_usecase.dart';
import 'package:lucidplus_machine_task/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

class DependenceInjection {
  void dependenceInject() {
    //firebase
    getIt.registerLazySingleton(() => FirebaseAuth.instance);
    getIt.registerLazySingleton(() => FirebaseFirestore.instance);
    //auth
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthSource>()),
    );
    getIt.registerLazySingleton<AuthSource>(
      () => AuthSourceImplementation(
        firebaseAuth: getIt<FirebaseAuth>(),
        firestore: getIt<FirebaseFirestore>(),
      ),
    );
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
    getIt.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(getIt<AuthRepository>()),
    );
    getIt.registerFactory(
      () => AuthBloc(loginUseCase: getIt(), signUpUseCase: getIt()),
    );
  }
}
