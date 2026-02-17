import 'package:dartz/dartz.dart';
import '../../../../core/app_errors/app_errors.dart';
import '../repository/auth_repository.dart';
import '../../data/model/auth_model.dart';
import '../../data/model/user_model.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<AppException, UserModel>> call({
    required AuthModel authModel,
  }) async {
    return await repository.userLogin(authModel: authModel);
  }
}
