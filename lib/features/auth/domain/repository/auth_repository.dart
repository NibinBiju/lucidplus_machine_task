import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucidplus_machine_task/core/app_errors/app_errors.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/auth_model.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';

abstract class AuthRepository {
  Future<Either<AppException, UserModel>> userLogin({
    required AuthModel authModel,
  });
  Future<Either<AppException, UserCredential>> userSignUp({
    required AuthModel authModel,
  });

  Future<void> logout();
}
