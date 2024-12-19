import 'dart:convert';
import 'package:http/http.dart' as http;

class ThingSpeakService {
  /// Fetches data for a specific field (N, P, or K) from ThingSpeak
  static Future<List<double>> fetchFieldData(
      String apiUrl, String fieldName) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract values for the specified field from the JSON response
        return List<double>.from(
          data['feeds']
              .map((feed) => double.tryParse(feed[fieldName] ?? '0') ?? 0),
        );
      } else {
        throw Exception(
            'Failed to load data for $fieldName: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data for $fieldName: $e');
    }
  }
}
