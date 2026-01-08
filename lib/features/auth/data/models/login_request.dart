class LoginRequest {
  final String phone;
  final String password;

  const LoginRequest({required this.phone, required this.password});
  Map<String, dynamic> toJson() {
    return {'phone': phone, 'password': password};
  }
}
