abstract class AuthLocalDataSource {
  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> getToken();

  Future<String?> getRefreshToken();

  Future<void> clearToken();
}
