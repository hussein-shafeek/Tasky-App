import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tasky_app/core/services/api_service.dart';
import 'package:tasky_app/core/api/apiConstant.dart';

class UploadService {
  final ApiService _api = ApiService();

  Future<String?> uploadImage(File file) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _api.dio.post(
        ApiConstant.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["image"];
      }
    } catch (e) {
      print("UPLOAD ERROR = $e");
    }
    return null;
  }
}
