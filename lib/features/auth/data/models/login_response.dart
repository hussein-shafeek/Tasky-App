class LoginResponse {
  final String id;
  final String accessToken;
  final String refreshToken;

  const LoginResponse({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    id: json['_id'] as String,
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
  );
}
