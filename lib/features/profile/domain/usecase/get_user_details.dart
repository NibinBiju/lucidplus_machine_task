import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';
import '../repository/profile_repository.dart';

class GetUser {
  final ProfileRepository repository;

  GetUser(this.repository);

  Future<UserModel> call(String uid) async {
    return await repository.getUser(uid);
  }
}
