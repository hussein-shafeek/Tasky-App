import 'package:tasky_app/core/services/api_service.dart';
import '../model/profile_model.dart';

class ProfileService {
  final ApiService _api = ApiService();

  Future<ProfileModel?> getProfile() async {
    final response = await _api.get('/auth/profile');

    print("PROFILE STATUS = ${response?.statusCode}");
    print("PROFILE DATA = ${response?.data}");

    if (response != null && response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    }

    return null;
  }
}
