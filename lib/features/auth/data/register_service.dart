// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static final AuthService _instance = AuthService._internal();
//   factory AuthService() => _instance;

//   final Dio dio;
//   String? _lastError;

//   AuthService._internal()
//     : dio = Dio(
//         BaseOptions(
//           baseUrl: "https://todo.iraqsapp.com/auth",
//           headers: {"Content-Type": "application/json"},
//         ),
//       ) {
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {

//           final prefs = await SharedPreferences.getInstance();
//           final token = prefs.getString("token");
//           if (token != null) {
//             options.headers["Authorization"] = "Bearer $token";
//           }
//           handler.next(options);
//         },
//         onError: (error, handler) async {

//           if (error.response?.statusCode == 401 &&
//               !error.requestOptions.path.contains("refresh-token")) {
//             final refreshed = await _refreshToken();
//             if (refreshed) {
//               final prefs = await SharedPreferences.getInstance();
//               final newToken = prefs.getString("token");
//               if (newToken != null) {
//                 error.requestOptions.headers["Authorization"] =
//                     "Bearer $newToken";

//                 final response = await dio.fetch(error.requestOptions);
//                 return handler.resolve(response);
//               }
//             }
//           }
//           handler.next(error);
//         },
//       ),
//     );
//   }

//   String? getLastError() => _lastError;

// Future<AuthResponse?> register({
//   required String phone,
//   required String password,
//   required String displayName,
//   required int experienceYears,
//   required String address,
//   required String level,
// }) async {
//   try {
//     final response = await dio.post(
//       "/register",
//       data: {
//         "phone": phone,
//         "password": password,
//         "displayName": displayName,
//         "experienceYears": experienceYears,
//         "address": address,
//         "level": level,
//       },
//     );

//     final auth = AuthResponse.fromJson(response.data);
//     final prefs = await SharedPreferences.getInstance();

//     await prefs.setString("token", auth.accessToken);
//     await prefs.setString("refresh_token", auth.refreshToken);
//     await prefs.setString("user_id", auth.userId);

//     _lastError = null;
//     return auth;
//   } on DioException catch (e) {
//     _lastError = e.response?.data?["message"] ?? "Register failed";
//     return null;
//   }
// }

//   // ================= LOGOUT =================
//   Future<bool> logout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("token");
//       if (token == null) return false;

//       await dio.post(
//         "/logout",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//         data: {"token": token},
//       );

//       await prefs.remove("token");
//       await prefs.remove("refresh_token");
//       await prefs.remove("user_id");
//       return true;
//     } on DioException catch (e) {
//       print("Logout failed: ${e.response?.data}");
//       return false;
//     }
//   }

//   // ================= TOKEN =================
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("token");
//   }

//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("token", token);
//   }

//   // ================= REFRESH TOKEN =================
//   Future<bool> _refreshToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final refreshToken = prefs.getString("refresh_token");
//     if (refreshToken == null) return false;

//     try {
//       final response = await dio.post(
//         "/refresh-token",
//         data: {"refreshToken": refreshToken},
//       );

//       final data = response.data;
//       await prefs.setString("token", data["access_token"]);
//       await prefs.setString("refresh_token", data["refresh_token"]);
//       print("Token refreshed successfully");
//       return true;
//     } catch (e) {
//       print("Refresh token failed: $e");
//       return false;
//     }
//   }
// }
