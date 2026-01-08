import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_local_data_source.dart';

class AuthSharedLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthSharedLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('accessToken', accessToken);
    sharedPref.setString('refreshToken', refreshToken);
  }

  @override
  Future<String?> getToken() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('accessToken') ?? '';
  }

  @override
  Future<String?> getRefreshToken() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('refreshToken') ?? '';
  }

  @override
  Future<void> clearToken() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove('accessToken');
    sharedPref.remove('refreshToken');
  }
}
