import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UploadService {
  final String baseUrl = "https://todo.iraqsapp.com";

  Future<String?> uploadImage(File file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("No token found");
      return null;
    }

    final url = Uri.parse("$baseUrl/upload/image");

    var request = http.MultipartRequest("POST", url);

    request.headers['Authorization'] = "Bearer $token";

    final ext = file.path.split(".").last.toLowerCase();
    final mediaType = ext == "png"
        ? MediaType("image", "png")
        : MediaType("image", "jpeg");

    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        file.path,
        contentType: mediaType,
      ),
    );

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("UPLOAD STATUS = ${response.statusCode}");
    print("UPLOAD BODY = $responseBody");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(responseBody);
      print("UPLOAD -> image filename: ${decoded["image"]}");
      return decoded["image"]; //  يرجّع اسم الصورة فقط
    }

    return null;
  }
}
