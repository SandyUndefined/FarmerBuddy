import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageAnalysisService {
  final ImagePicker _picker = ImagePicker();

  Future<Map<String, dynamic>> takePictureAndAnalyze() async {
    try {
      // Capture Image
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return {'error': 'No image selected'};

      File imageFile = File(photo.path);

      // Convert to JPG
      final image = img.decodeImage(imageFile.readAsBytesSync());
      final jpg = img.encodeJpg(image!);

      // Get temporary directory and save JPG
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.jpg');
      await tempFile.writeAsBytes(jpg);

      // Read the file as base64 encoded string
      String base64Image = base64Encode(await tempFile.readAsBytes());

      // Prepare the API request
      final url = Uri.parse(
          'https://detect.roboflow.com/lettuce-disease-detection-zdd8k/1?api_key=NDsh01m71LfhdiPoxXcb');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: base64Image,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to analyze image'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
