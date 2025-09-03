import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  Future<File?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw Exception('Lỗi khi chọn ảnh: ${e.toString()}');
    }
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
      );

      request.fields['upload_preset'] = uploadPreset;

      var fileStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        length,
        filename: imageFile.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      print('Before add, files: ${request.files.length}');
      print('multipartFile: $multipartFile');
      request.files.add(multipartFile);
      print('After add, files: ${request.files.length}');

      var response = await request.send();
      print('Response status: ${response.statusCode}');
      var responseData = await response.stream.bytesToString();
      print('Response body: $responseData');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['secure_url'] as String;
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi upload ảnh: ${e.toString()}');
    }
  }
}
