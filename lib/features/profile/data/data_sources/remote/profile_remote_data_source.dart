import 'package:tasky_app/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}
