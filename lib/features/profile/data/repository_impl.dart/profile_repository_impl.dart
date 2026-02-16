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
}
