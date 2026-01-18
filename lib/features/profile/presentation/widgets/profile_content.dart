import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:tasky_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:tasky_app/features/profile/presentation/widgets/profile_error.dart';
import 'package:tasky_app/features/profile/presentation/widgets/profile_list.dart';
import 'package:tasky_app/features/profile/presentation/widgets/profile_loading.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) return ProfileLoadingState();
          if (state is ProfileError)
            return ProfileErrorWidget(message: state.message);
          if (state is ProfileSuccess)
            return ProfileList(profile: state.profile);
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
