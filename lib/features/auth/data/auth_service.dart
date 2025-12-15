import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final Dio dio;
  String? _lastError;

  AuthService._internal()
    : dio = Dio(
        BaseOptions(
          baseUrl: "https://todo.iraqsapp.com/auth",
          headers: {"Content-Type": "application/json"},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // إضافة الـ Authorization header تلقائي
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString("token");
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // لو response 401 حاول refresh token
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains("refresh-token")) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final prefs = await SharedPreferences.getInstance();
              final newToken = prefs.getString("token");
              if (newToken != null) {
                error.requestOptions.headers["Authorization"] =
                    "Bearer $newToken";
                // إعادة تنفيذ الطلب الأصلي
                final response = await dio.fetch(error.requestOptions);
                return handler.resolve(response);
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  String? getLastError() => _lastError;

  // ================= REGISTER =================
  Future<bool> register({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  }) async {
    try {
      final response = await dio.post(
        "/register",
        data: {
          "phone": phone,
          "password": password,
          "displayName": displayName,
          "experienceYears": experienceYears,
          "address": address,
          "level": level,
        },
      );

      _lastError = null;
      return response.statusCode! >= 200 && response.statusCode! < 300;
    } on DioException catch (e) {
      _lastError = e.response?.data?["message"] ?? "Register failed";
      return false;
    } catch (e) {
      _lastError = "Register failed";
      return false;
    }
  }

  // ================= LOGIN =================
  Future<String?> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "/login",
        data: {"phone": phone, "password": password},
      );

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("token", data["access_token"]);
      await prefs.setString("refresh_token", data["refresh_token"]);
      await prefs.setString("user_id", data["_id"]);

      _lastError = null;
      return data["access_token"];
    } on DioException catch (e) {
      _lastError = e.response?.data?["message"] ?? "Login failed";
      return null;
    } catch (e) {
      _lastError = "Login failed";
      return null;
    }
  }

  // ================= LOGOUT =================
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      if (token == null) return false;

      await dio.post(
        "/logout",
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {"token": token},
      );

      await prefs.remove("token");
      await prefs.remove("refresh_token");
      await prefs.remove("user_id");
      return true;
    } on DioException catch (e) {
      print("Logout failed: ${e.response?.data}");
      return false;
    }
  }

  // ================= TOKEN =================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  // ================= REFRESH TOKEN =================
  Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString("refresh_token");
    if (refreshToken == null) return false;

    try {
      final response = await dio.post(
        "/refresh-token",
        data: {"refreshToken": refreshToken},
      );

      final data = response.data;
      await prefs.setString("token", data["access_token"]);
      await prefs.setString("refresh_token", data["refresh_token"]);
      print("Token refreshed successfully");
      return true;
    } catch (e) {
      print("Refresh token failed: $e");
      return false;
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   final String baseUrl = "https://todo.iraqsapp.com/auth";
//   String? _lastError;
//   String? getLastError() => _lastError;
//   Future<bool> register({
//     required String phone,
//     required String password,
//     required String displayName,
//     required int experienceYears,
//     required String address,
//     required String level,
//   }) async {
//     final url = Uri.parse('$baseUrl/register');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'phone': phone,
//         'password': password,
//         'displayName': displayName,
//         'experienceYears': experienceYears,
//         'address': address,
//         'level': level,
//       }),
//     );

//     //print("STATUS: ${response.statusCode}");
//     //print("RESPONSE BODY: ${response.body}");

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       _lastError = null;
//       return true;
//     } else {
//       try {
//         final data = jsonDecode(response.body);
//         _lastError = data['message'] ?? "Register failed";
//       } catch (e) {
//         _lastError = "Register failed";
//       }
//       return false;
//     }
//   }

//   Future<String?> login({
//     required String phone,
//     required String password,
//   }) async {
//     final url = Uri.parse('$baseUrl/login');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'phone': phone, 'password': password}),
//     );

//     // print("STATUS: ${response.statusCode}");
//     //print("RESPONSE BODY: ${response.body}");

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       final data = jsonDecode(response.body);
//       String token = data['access_token'];

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//       await prefs.setString('refresh_token', data['refresh_token']);
//       await prefs.setString('user_id', data['_id']);

//       _lastError = null;
//       return token;
//     } else {
//       try {
//         final data = jsonDecode(response.body);
//         _lastError = data['message'] ?? "Login failed";
//       } catch (e) {
//         _lastError = "Login failed";
//       }
//       return null;
//     }
//   }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//   }

//   Future<bool> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     if (token == null) return false;

//     final url = Uri.parse('$baseUrl/logout');

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'token': token}),
//     );

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       await prefs.remove('token');
//       await prefs.remove('refresh_token');
//       await prefs.remove('user_id');
//       return true;
//     } else {
//       print('Logout failed: ${response.body}');
//       return false;
//     }
//   }
// }
