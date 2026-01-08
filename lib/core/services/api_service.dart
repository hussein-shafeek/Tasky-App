import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/api/apiConstant.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio dio;

  ApiService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            if (error.requestOptions.path.contains("refresh-token")) {
              return handler.next(error);
            }
            final success = await _refreshToken();
            if (success) {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');
              error.requestOptions.headers["Authorization"] = "Bearer $token";

              final response = await dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Response?> get(String endpoint) async {
    try {
      return await dio.get(endpoint);
    } catch (e) {
      print("GET request error: $e");
      return null;
    }
  }

  Future<Response?> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      return await dio.post(endpoint, data: body);
    } catch (e) {
      print("POST request error: $e");
      return null;
    }
  }

  Future<Response?> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      return await dio.put(endpoint, data: body);
    } catch (e) {
      print("PUT request error: $e");
      return null;
    }
  }

  Future<Response?> delete(String endpoint) async {
    try {
      return await dio.delete(endpoint);
    } catch (e) {
      print("DELETE request error: $e");
      return null;
    }
  }

  Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await dio.post(
        ApiConstant.refreshToken,
        data: {"refreshToken": refreshToken},
      );

      final data = response.data;
      await prefs.setString("token", data["access_token"]);
      await prefs.setString("refresh_token", data["refresh_token"]);
      print("Token refreshed successfully");
      return true;
    } catch (e) {
      print("Refresh token failed: $e");
    }
    return false;
  }
}
