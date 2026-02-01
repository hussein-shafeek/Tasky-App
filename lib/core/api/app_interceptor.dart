import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/routes/app_router.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import '../../core/di/dependency_injection.dart';
import '../api/status_code.dart';
import 'end_points.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;
  final SharedPreferences prefs;

  AppInterceptors({required this.dio, required this.prefs});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getString("accessToken"); // بدل "token"
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    getIt.unregister<CancelToken>();
    getIt.registerSingleton<CancelToken>(CancelToken());
    options.cancelToken = getIt<CancelToken>();

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ToDo
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      log("err.response?.statusCode ${err.response?.statusCode}");
    }
    if (err.response?.statusCode == StatusCode.unauthorized) {
      // Handle 401 Unauthorized
      String? accessToken = prefs.getString("accessToken");
      String? refreshToken = prefs.getString("refreshToken");
      log(accessToken.toString());
      log(refreshToken.toString());
      if (err.response?.statusCode == 403) {
        AppRouter.router().go(Routes.loginScreen);
      } else if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          dio.options.baseUrl = EndPoints.baseUrl;
          final refreshEndpoint =
              '${EndPoints.refreshToken}?token=$refreshToken';
          final response = await dio.post(
            refreshEndpoint,
            options: Options(
              headers: {'Content-Type': 'application/json'},
              validateStatus: (status) => true,
            ),
          );

          log(
            "Refresh token response: ${response.statusCode} - ${response.data}",
          );

          if (response.statusCode == StatusCode.ok) {
            String newAccessToken = response.data["token"];
            prefs.setString("accessToken", newAccessToken);
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            return handler.resolve(await dio.fetch(err.requestOptions));
          } else {
            log("Token refresh failed with status: ${response.statusCode}");
            await prefs.clear();
            AppRouter.router().go(Routes.loginScreen);
          }
        } catch (refreshError) {
          log("Error during token refresh: $refreshError");
          await prefs.clear();
          AppRouter.router().go(Routes.loginScreen);
        }
      } else {
        await prefs.clear();
        AppRouter.router().go(Routes.loginScreen);
      }
    } else if (err.response?.statusCode == StatusCode.forbidden) {
      if (!err.response?.data['message'].contains('old password is wrong')) {
        await prefs.clear();
        AppRouter.router().go(Routes.loginScreen);
      }
    }
    super.onError(err, handler);
  }
}
