import 'dart:convert';
import 'package:tasky_app/core/services/api_service.dart';
import '../model/profile_model.dart';

class ProfileService {
  final ApiService _api = ApiService();

  Future<ProfileModel?> getProfile() async {
    final response = await _api.get('/auth/profile');
    print("PROFILE STATUS = ${response?.statusCode}");
    print("PROFILE BODY = ${response?.body}");

    if (response != null && response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return ProfileModel.fromJson(data);
      } else {
        print("WARNING: /auth/profile returned EMPTY BODY");
      }
    }

    return null;
  }
}
