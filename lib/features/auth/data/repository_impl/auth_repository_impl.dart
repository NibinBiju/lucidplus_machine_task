import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucidplus_machine_task/core/app_errors.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/auth_model.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';
import 'package:lucidplus_machine_task/features/auth/data/source/auth_source.dart';
import 'package:lucidplus_machine_task/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthSource authSource;

  AuthRepositoryImpl(this.authSource);

  @override
  Future<Either<AppException, UserModel>> userLogin({
    required AuthModel authModel,
  }) async {
    return await authSource.userLogin(authModel: authModel);
  }

  @override
  Future<Either<AppException, UserCredential>> userSignUp({
    required AuthModel authModel,
  }) async {
    return await authSource.userSignUp(authModel: authModel);
  }
}
