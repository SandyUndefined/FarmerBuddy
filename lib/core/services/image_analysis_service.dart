import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageAnalysisService {
  final ImagePicker _picker = ImagePicker();
  final String openAIKey = dotenv.env['OPENAI_API_KEY'] ?? '';

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

      // Make OpenAI API request
      final response = await _analyzeImageWithOpenAI(base64Image);

      if (response['error'] != null) {
        return {'error': response['error']};
      } else {
        return {'analysis': response['analysis']};
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> _analyzeImageWithOpenAI(
      String base64Image) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final headers = {
      "Authorization": "Bearer $openAIKey",
      "Content-Type": "application/json",
    };

    final body = {
      "model": "gpt-4o",
      "messages": [
        {
          "role": "user",
          "content":
              "Analyze this image of leaves, fruits, vegetables, or crops and provide the following:\n1. Detect any disease present.\n2. Name the disease.\n3. Provide information about the disease.\n4. Suggest treatment and best practices to cure or mitigate the disease.",
        }
      ],
      "image": base64Image,
      "temperature": 0.7,
      "max_tokens": 2000
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'analysis': responseData['choices'][0]['message']['content'].trim()
        };
      } else {
        return {'error': 'Failed to analyze image: ${response.body}'};
      }
    } catch (e) {
      return {'error': 'Error communicating with OpenAI: $e'};
    }
  }
}
