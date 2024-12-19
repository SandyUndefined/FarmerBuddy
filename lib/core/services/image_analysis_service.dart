import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageAnalysisService {
  final ImagePicker _picker = ImagePicker();

  Future<Map<String, dynamic>> takePictureAndAnalyze() async {
    try {
      // Open camera
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return {'error': 'No image selected'};

      File imageFile = File(photo.path);

      // Convert to JPG
      final image = img.decodeImage(imageFile.readAsBytesSync());
      final jpg = img.encodeJpg(image!);

      // Save JPG to temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.jpg');
      await tempFile.writeAsBytes(jpg);

      // Read the file as base64
      String base64Image = base64Encode(await tempFile.readAsBytes());

      // Make API request
      final url = Uri.parse(
          'https://detect.roboflow.com/lettuce-disease-detection-zdd8k/1?api_key=NDsh01m71LfhdiPoxXcb');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: base64Image,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'predictions': data['predictions']};
      } else {
        return {'error': 'Analysis failed: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }
}
