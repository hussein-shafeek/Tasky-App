import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "https://todo.iraqsapp.com";

  Future<http.Response?> get(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token saved");
      return null;
    }

    final url = Uri.parse(baseUrl + endpoint);

    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      bool success = await _refreshToken();

      if (success) {
        token = prefs.getString('token');

        response = await http.get(
          url,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        );
      } else {
        print("Refresh failed → logout");
        return null;
      }
    }

    return response;
  }

  Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();

    String? refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) return false;

    final url = Uri.parse("$baseUrl/auth/refresh-token");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    print("REFRESH STATUS: ${response.statusCode}");
    print("REFRESH BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      prefs.setString("token", data["access_token"]);
      prefs.setString("refresh_token", data["refresh_token"]);

      print("Token refreshed successfully");
      return true;
    }

    return false;
  }
}
