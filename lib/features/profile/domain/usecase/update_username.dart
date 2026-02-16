import 'package:lucidplus_machine_task/features/profile/domain/repository/profile_repository.dart';

class UpdateUsername {
  final ProfileRepository repository;

  UpdateUsername(this.repository);

  Future<void> call({required String userId, required String newName}) {
    return repository.updateName(userId: userId, newName: newName);
  }
}
