// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tasky_app/features/auth/data/auth_response.dart';

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

//   Future<AuthResponse?> login({
//     required String phone,
//     required String password,
//   }) async {
//     try {
//       final response = await dio.post(
//         "/login",
//         data: {"phone": phone, "password": password},
//       );

//       final auth = AuthResponse.fromJson(response.data);
//       final prefs = await SharedPreferences.getInstance();

//       await prefs.setString("token", auth.accessToken);
//       await prefs.setString("refresh_token", auth.refreshToken);
//       await prefs.setString("user_id", auth.userId);

//       _lastError = null;
//       return auth;
//     } on DioException catch (e) {
//       _lastError = e.response?.data?["message"] ?? "Login failed";
//       return null;
//     }
//   }
// }
