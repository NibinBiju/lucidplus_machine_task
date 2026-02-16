import 'package:dartz/dartz.dart';

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
}
