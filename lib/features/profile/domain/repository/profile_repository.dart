import 'package:dartz/dartz.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';

abstract class ProfileRepository {
  Future<void> updateThemeMode({
    required String userId,
    required bool isDarkMode,
  });

  Future<bool> getThemeMode(String userId);
  Future<Either<String, String>> updateName({
    required String userId,
    required String newName,
  });

  Future<UserModel> getUser(String uid);
}
