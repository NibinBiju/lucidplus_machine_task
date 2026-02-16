import 'package:lucidplus_machine_task/features/profile/domain/repository/profile_repository.dart';

class UpdateThemeUseCase {
  final ProfileRepository repository;

  UpdateThemeUseCase(this.repository);

  Future<void> call({
    required String userId,
    required bool isDarkMode,
  }) {
    return repository.updateThemeMode(
      userId: userId,
      isDarkMode: isDarkMode,
    );
  }
}
