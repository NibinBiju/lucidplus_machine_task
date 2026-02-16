import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:lucidplus_machine_task/features/profile/domain/repository/profile_repository.dart';

part 'update_name_state.dart';

class UpdateNameCubit extends Cubit<UpdateNameState> {
  final ProfileRepository repository;

  UpdateNameCubit(this.repository) : super(UpdateNameInitial());

  void updateName({required String userId, required String newName}) async {
    var returnedData = await repository.updateName(
      userId: userId,
      newName: newName,
    );

    returnedData.fold(
      (error) {
        emit(UpdateNameFailed(message: error));
      },
      (success) {
        emit(UpdateNameSuccess(message: success));
      },
    );
  }
}
