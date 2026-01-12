import 'package:tasky_app/features/auth/domain/entities/user_entity.dart';

class AuthResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String? displayName;

  AuthResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    this.displayName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['_id'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      displayName: json['displayName'],
    );
  }

  UserEntity get toEntity => UserEntity(
    userId: userId,
    accessToken: accessToken,
    refreshToken: refreshToken,
    displayName: displayName,
  );
}
