import 'package:dartz/dartz.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';
import 'package:lucidplus_machine_task/features/profile/data/source/profile_source.dart';
import 'package:lucidplus_machine_task/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> updateThemeMode({
    required String userId,
    required bool isDarkMode,
  }) {
    return remoteDataSource.updateThemeMode(
      userId: userId,
      isDarkMode: isDarkMode,
    );
  }

  @override
  Future<bool> getThemeMode(String userId) {
    return remoteDataSource.getThemeMode(userId);
  }

  @override
  Future<Either<String, String>> updateName({
    required String userId,
    required String newName,
  }) {
    return remoteDataSource.updateName(userId: userId, newName: newName);
  }

  @override
  Future<UserModel> getUser(String uid) {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}
