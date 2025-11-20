import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadService {
  final String baseUrl = "https://todo.iraqsapp.com";

  Future<Map<String, dynamic>?> uploadImage(File file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("No token found");
      return null;
    }

    final url = Uri.parse("$baseUrl/upload/image");

    var request = http.MultipartRequest("POST", url);

    request.headers['Authorization'] = "Bearer $token";
    request.headers['Content-Type'] = "multipart/form-data";

    /// نوع الصورة
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
    var body = await response.stream.bytesToString();

    print("UPLOAD STATUS = ${response.statusCode}");
    print("UPLOAD BODY = $body");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"status": true, "body": body};
    } else {
      print("Upload failed: ${response.statusCode} - $body");
      return null;
    }
  }
}
