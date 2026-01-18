import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:tasky_app/features/profile/domain/use_cases/get_profile_usecase.dart';
import 'package:tasky_app/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({required this.getProfileUseCase}) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    final result = await getProfileUseCase.call();

    result.fold(
      (failure) {
        emit(ProfileError(failure.errMessage));
      },
      (profile) {
        emit(ProfileSuccess(profile));
      },
    );
  }
}
