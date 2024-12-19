import 'package:flutter/material.dart';
import '../core/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  List<Map<String, dynamic>> _dailyWeather = [];

  List<Map<String, dynamic>> get dailyWeather => _dailyWeather;

  Future<void> fetchWeather(double lat, double lon) async {
    final service = WeatherService();
    final rawData = await service.fetchWeather(lat, lon);

    // Process data to extract one forecast per day
    _dailyWeather = _processDailyWeather(rawData['list']);
    notifyListeners();
  }

  List<Map<String, dynamic>> _processDailyWeather(List<dynamic> forecastList) {
    final Map<String, Map<String, dynamic>> dailyData = {};

    for (var entry in forecastList) {
      final dateTime = DateTime.parse(entry['dt_txt']);
      final date = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

      // Select midday entry as representative for each day
      if (dailyData[date] == null || dateTime.hour == 12) {
        dailyData[date] = {
          'date': dateTime,
          'temp': entry['main']['temp'],
          'condition': entry['weather'][0]['main'],
        };
      }
    }

    // Convert to a sorted list
    return dailyData.values.toList()..sort((a, b) => a['date'].compareTo(b['date']));
  }


}
