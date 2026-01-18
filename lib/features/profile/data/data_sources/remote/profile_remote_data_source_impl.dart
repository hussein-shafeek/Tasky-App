import 'package:tasky_app/core/api/api_consumer.dart';
import 'package:tasky_app/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:tasky_app/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProfileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ProfileModel> getProfile() async {
    final response = await apiConsumer.get(path: '/auth/profile');

    return ProfileModel.fromJson(response);
  }
}
