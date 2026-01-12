import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/api/api_consumer.dart';
import 'package:tasky_app/core/api/end_points.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'auth_remote_data_source.dart';
import '../../models/auth_response.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<AuthResponse> login(LoginRequest loginRequest) async {
    final response = await apiConsumer.post(
      path: EndPoints.login,
      body: loginRequest.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  @override
  Future<AuthResponse> register(RegisterRequest registerRequest) async {
    final response = await apiConsumer.post(
      path: EndPoints.register,
      body: registerRequest.toJson(),
    );
    return AuthResponse.fromJson(response);
  }

  @override
  Future<Unit> logout() async {
    await apiConsumer.post(path: EndPoints.logout);
    return unit;
  }
}
