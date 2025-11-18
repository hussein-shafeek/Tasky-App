import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://todo.iraqsapp.com/auth";

  // =======================
  // تسجيل مستخدم جديد (Register)
  // =======================
  Future<bool> register({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phone,
        'password': password,
        'displayName': displayName,
        'experienceYears': experienceYears,
        'address': address,
        'level': level,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; // تم التسجيل بنجاح
    } else {
      print('Register failed: ${response.body}');
      return false;
    }
  }

  // =======================
  // تسجيل دخول (Login)
  // =======================
  Future<String?> login({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    // السيرفر بيرجع 201 مش 200
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      String token = data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('refresh_token', data['refresh_token']);
      await prefs.setString('user_id', data['_id']);

      return token;
    } else {
      print('StatusCode = ${response.statusCode}');
      print('Response = ${response.body}');

      return null;
    }
  }

  // =======================
  // جلب التوكن المخزن
  // =======================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
