import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey =
      "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";

Future<String> getSoilHealthReport(
      Map<String, dynamic> data, String language) async {
    // Pass the language parameter to the prompt generator
    final prompt = _generateSoilHealthPrompt(data, language);
    return await _callOpenAIChatAPI(prompt, language);
  }

  Future<String> getWateringAdvisoryReport(
      Map<String, dynamic> data, String date, String language) async {
    // Pass the language parameter to the prompt generator
    final prompt = _generateWateringPrompt(data, date, language);
    return await _callOpenAIChatAPI(prompt, language);
  }


String _generateSoilHealthPrompt(Map<String, dynamic> data, String language) {
  if (language == 'hi') {
    return """
निम्नलिखित डेटा के आधार पर एक विस्तृत मृदा स्वास्थ्य रिपोर्ट तैयार करें:
- नाइट्रोजन: ${data['n']} मिलीग्राम/किलोग्राम
- फास्फोरस: ${data['p']} मिलीग्राम/किलोग्राम
- पोटैशियम: ${data['k']} मिलीग्राम/किलोग्राम
- तापमान: ${data['temperature']} °सेल्सियस
- आर्द्रता: ${data['humidity']}%
- मृदा नमी: ${data['soilMoisture']}%

कृपया इस मृदा स्वास्थ्य स्थिति के लिए कौन सी फसलें सबसे उपयुक्त होंगी उनके लिए सिफारिशें शामिल करें। रिपोर्ट को विस्तारपूर्वक हिंदी में तैयार करें।
""";
  } else {
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
}


String _generateWateringPrompt(
      Map<String, dynamic> data, String date, String language) {
    if (language == 'hi') {
      return """
निम्नलिखित मृदा स्वास्थ्य डेटा और चुनी गई तारीख ($date) के आधार पर, फसलों के लिए विस्तृत जल देने की सलाह प्रदान करें:
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
Based on the soil health data and the selected date ($date), generate a comprehensive watering advisory report for crops:
- Nitrogen: ${data['n']} mg/kg
- Phosphorus: ${data['p']} mg/kg
- Potassium: ${data['k']} mg/kg
- Temperature: ${data['temperature']} °C
- Humidity: ${data['humidity']}%
- Soil Moisture: ${data['soilMoisture']}%

Please provide detailed recommendations.
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
      "model": "gpt-3.5-turbo",
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
