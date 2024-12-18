import 'dart:convert';
import 'package:http/http.dart' as http;

class ThingSpeakService {
  static Future<List<double>> fetchNPK(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract values from the JSON response
        return List<double>.from(
          data['feeds']
              .map((feed) => double.tryParse(feed['field1'] ?? '0') ?? 0),
        );
      } else {
        throw Exception('Failed to load NPK data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching NPK data: $e');
    }
  }
}
