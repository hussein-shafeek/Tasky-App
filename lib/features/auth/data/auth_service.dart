import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://todo.iraqsapp.com/auth";

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
      return true;
    } else {
      print('Register failed: ${response.body}');
      return false;
    }
  }

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

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return false;

    final url = Uri.parse('$baseUrl/logout');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await prefs.remove('token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_id');
      return true;
    } else {
      print('Logout failed: ${response.body}');
      return false;
    }
  }
}
