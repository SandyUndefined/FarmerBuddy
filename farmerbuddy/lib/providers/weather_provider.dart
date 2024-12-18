import 'package:flutter/material.dart';
import '../core/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic> _weatherData = {};

  Map<String, dynamic> get weatherData => _weatherData;

  Future<void> fetchWeather(double lat, double lon) async {
    final service = WeatherService();
    _weatherData = await service.fetchWeather(lat, lon);
    notifyListeners();
  }
}
