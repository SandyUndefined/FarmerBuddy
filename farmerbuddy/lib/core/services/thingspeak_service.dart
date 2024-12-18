import 'dart:convert';
import 'package:http/http.dart' as http;

class ThingSpeakService {
  static Future<List<double>> fetchNPK(String chartUrl) async {
    try {
      final response = await http.get(Uri.parse(chartUrl));
      if (response.statusCode == 200) {
        // Extract NPK values from ThingSpeak (assuming JSON response)
        final data = jsonDecode(response.body);
        return List<double>.from(data['feeds'].map((feed) => feed['field1']));
      } else {
        throw Exception('Failed to load NPK data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
