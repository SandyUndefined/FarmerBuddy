import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  Future<String> getSoilHealthReport(
      Map<String, dynamic> data, String language, String cropType) async {
    final prompt = _generateSoilHealthPrompt(data, language, cropType);
    return await _callOpenAIChatAPI(prompt, language);
  }

  Future<String> getWateringAdvisoryReport(Map<String, dynamic> data,
      String date, String language, String cropType) async {
    final prompt = _generateWateringPrompt(data, date, language, cropType);
    return await _callOpenAIChatAPI(prompt, language);
  }

  String _generateSoilHealthPrompt(
      Map<String, dynamic> data, String language, String cropType) {
    if (language == 'hi') {
      return """
चुनी गई फसल: $cropType के लिए निम्नलिखित डेटा के आधार पर विस्तृत मृदा स्वास्थ्य रिपोर्ट तैयार करें:
- नाइट्रोजन: ${data['n']} मिलीग्राम/किलोग्राम
- फास्फोरस: ${data['p']} मिलीग्राम/किलोग्राम
- पोटैशियम: ${data['k']} मिलीग्राम/किलोग्राम
- तापमान: ${data['temperature']} °सेल्सियस
- आर्द्रता: ${data['humidity']}%
- मृदा नमी: ${data['soilMoisture']}%

कृपया इस मृदा स्वास्थ्य स्थिति के लिए फसल की उपयुक्तता और किसी भी सुधारात्मक उपायों को शामिल करें। रिपोर्ट को विस्तारपूर्वक हिंदी में तैयार करें।
""";
    } else {
      return """
Generate a detailed soil health report for the selected crop: $cropType based on the following data:
- Nitrogen: ${data['n']} mg/kg
- Phosphorus: ${data['p']} mg/kg
- Potassium: ${data['k']} mg/kg
- Temperature: ${data['temperature']} °C
- Humidity: ${data['humidity']}%
- Soil Moisture: ${data['soilMoisture']}%

Include recommendations for the suitability of the crop and any corrective measures if needed.
""";
    }
  }

  String _generateWateringPrompt(Map<String, dynamic> data, String date,
      String language, String cropType) {
    if (language == 'hi') {
      return """
चुनी गई फसल: $cropType और चयनित तारीख ($date) के लिए निम्नलिखित मृदा स्वास्थ्य डेटा के आधार पर, फसलों के लिए जल देने की विस्तृत सलाह प्रदान करें:
- नाइट्रोजन: ${data['n']} मिलीग्राम/किलोग्राम
- फास्फोरस: ${data['p']} मिलीग्राम/किलोग्राम
- पोटैशियम: ${data['k']} मिलीग्राम/किलोग्राम
- तापमान: ${data['temperature']} °सेल्सियस
- आर्द्रता: ${data['humidity']}%
- मृदा नमी: ${data['soilMoisture']}%

कृपया विस्तृत सलाह हिंदी में तैयार करें।
""";
    } else {
      return """
Generate a comprehensive watering advisory report for the selected crop: $cropType based on the soil health data and the selected date ($date):
- Nitrogen: ${data['n']} mg/kg
- Phosphorus: ${data['p']} mg/kg
- Potassium: ${data['k']} mg/kg
- Temperature: ${data['temperature']} °C
- Humidity: ${data['humidity']}%
- Soil Moisture: ${data['soilMoisture']}%

Provide detailed recommendations for watering.
""";
    }
  }

  Future<String> _callOpenAIChatAPI(String prompt, String language) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };
    final messages = [
      {
        "role": "user",
        "content": language == 'hi'
            ? "कृपया निम्नलिखित का उत्तर हिंदी में विस्तारपूर्वक दें:\n$prompt"
            : prompt
      }
    ];

    final body = {
      "model": "gpt-4",
      "messages": messages,
      "temperature": 0.7,
      "max_tokens": 2000, // Increase max tokens for detailed responses
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure proper UTF-8 decoding
        return responseData['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to get response from OpenAI: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error communicating with OpenAI: $e');
    }
  }
}
