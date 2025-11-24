import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/models/add_task_model.dart';
import 'package:tasky_app/core/models/task_model.dart';
import 'package:tasky_app/core/models/update_model.dart';

class TodoService {
  static const String baseUrl = "https://todo.iraqsapp.com";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No access token found");
    }

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Future<http.Response> _handleRequest(
    Future<http.Response> Function() request,
  ) async {
    http.Response response = await request();

    if (response.statusCode == 401) {
      // Try refresh token
      final success = await _refreshToken();
      if (!success) throw Exception("Unauthorized & refresh failed");

      // Retry original request with new token
      response = await request();
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString("token", data["access_token"]);
      await prefs.setString("refresh_token", data["refresh_token"]);
      return true;
    }

    return false;
  }

  Future<List<TaskModel>> getTodos({int page = 1}) async {
    final url = Uri.parse("$baseUrl/todos?page=$page");

    final response = await _handleRequest(() async {
      return http.get(url, headers: await _getHeaders());
    });

    if (response.statusCode != 200) throw Exception("Failed to load todos");

    final List data = jsonDecode(response.body);
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> getTodoById(String id) async {
    final url = Uri.parse("$baseUrl/todos/$id");

    final response = await _handleRequest(() async {
      return http.get(url, headers: await _getHeaders());
    });

    if (response.statusCode != 200) throw Exception("Todo not found");

    final json = jsonDecode(response.body);
    return TaskModel.fromJson(json);
  }

  Future<TaskModel> createTodo(CreateTodoModel model) async {
    final url = Uri.parse("$baseUrl/todos");

    final response = await _handleRequest(() async {
      return http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(model.toJson()),
      );
    });

    print("CREATE TODO STATUS: ${response.statusCode}");
    print("CREATE TODO BODY: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create todo");
    }

    final json = jsonDecode(response.body);
    return TaskModel.fromJson(json);
  }

  Future<bool> updateTodo({
    required String id,
    required UpdateTodoModel model,
  }) async {
    final url = Uri.parse("$baseUrl/todos/$id");

    final response = await _handleRequest(() async {
      return http.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(model.toJson()),
      );
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to update todo");
    }

    final result = jsonDecode(response.body); // API returns 1
    return result == 1;
  }

  Future<bool> deleteTodo(String id) async {
    final url = Uri.parse("$baseUrl/todos/$id");

    final response = await _handleRequest(() async {
      return http.delete(url, headers: await _getHeaders());
    });

    final result = int.tryParse(response.body.trim());
    return result == 1;
  }
}
