import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';
import 'package:lucidplus_machine_task/features/profile/domain/repository/profile_repository.dart';

part 'get_user_details_state.dart';

class GetUserDetailsCubit extends Cubit<GetUserDetailsState> {
  final ProfileRepository profileRepository;
  GetUserDetailsCubit(this.profileRepository) : super(GetUserDetailsInitial());

  Future<void> getUserDetails({required String uid}) async {
    var data = await profileRepository.getUser(uid);
    print("called");
    print("User name:${data.name}");

    if (data.name.isEmpty) {
      emit(GetUserDetailsFailed(message: "Failed to get user details"));
    } else {
      emit(GetUserDetailsSuccess(userModel: data));
    }
  }
}
