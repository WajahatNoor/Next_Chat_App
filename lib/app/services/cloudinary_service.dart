import 'dart:io';
import 'package:dio/dio.dart';
import 'package:next_chat/app/res/app_constants.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  Future<String> uploadProfileImage(File imageFile) async {
    final formData = FormData.fromMap({
      'upload_preset': AppConstants.uploadPreset,
      'file': await MultipartFile.fromFile(imageFile.path),
    });

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/${AppConstants.cloudName}/image/upload',
      data: formData,
    );

    final imageUrl = response.data['secure_url'] as String?;

    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('Cloudinary did not return an image URL.');
    }

    return imageUrl;
  }
}
