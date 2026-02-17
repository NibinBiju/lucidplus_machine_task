import 'package:dartz/dartz.dart';
import '../../../../core/app_errors/app_errors.dart';
import '../repository/auth_repository.dart';
import '../../data/model/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<AppException, UserCredential>> call({
    required AuthModel authModel,
  }) async {
    return await repository.userSignUp(authModel: authModel);
  }
}
