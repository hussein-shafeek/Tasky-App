class AuthTokens {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String? displayName;

  const AuthTokens({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    this.displayName,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      userId: json['_id'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      displayName: json['displayName'],
    );
  }
}
