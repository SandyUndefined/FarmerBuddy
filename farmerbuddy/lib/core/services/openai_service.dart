import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey =
      "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";

  Future<String> getSoilHealthReport(Map<String, dynamic> data) async {
    final prompt = _generateSoilHealthPrompt(data);
    return await _callOpenAIChatAPI(prompt);
  }

  Future<String> getWateringAdvisoryReport(
      Map<String, dynamic> data, String date) async {
    final prompt = _generateWateringPrompt(data, date);
    return await _callOpenAIChatAPI(prompt);
  }

  String _generateSoilHealthPrompt(Map<String, dynamic> data) {
    return """
Generate a detailed soil health report based on the following data:
- Nitrogen: ${data['n']} mg/kg
- Phosphorus: ${data['p']} mg/kg
- Potassium: ${data['k']} mg/kg
- Temperature: ${data['temperature']} °C
- Humidity: ${data['humidity']}%
- Soil Moisture: ${data['soilMoisture']}%

Please include recommendations for which crops would be best suited for this soil health condition.
""";
  }

  String _generateWateringPrompt(Map<String, dynamic> data, String date) {
    return """
Based on the soil health data:
- Nitrogen: ${data['n']} mg/kg
- Phosphorus: ${data['p']} mg/kg
- Potassium: ${data['k']} mg/kg
- Temperature: ${data['temperature']} °C
- Humidity: ${data['humidity']}%
- Soil Moisture: ${data['soilMoisture']}%

And the selected date: $date, generate a comprehensive watering advisory report for crops.
""";
  }

  Future<String> _callOpenAIChatAPI(String prompt) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };
    final body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": prompt}
      ],
      "temperature": 0.7,
      "max_tokens": 1000,
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to get response from OpenAI: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error communicating with OpenAI: $e');
    }
  }
}
