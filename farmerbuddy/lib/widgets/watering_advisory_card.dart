import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WateringAdvisoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    final forecast = weatherProvider.dailyWeather;

    String wateringAdvice = "No forecast data available.";
    if (forecast.isNotEmpty) {
      final precipitation = forecast[0]['rain'] ?? 0; // Example: rain in mm
      if (precipitation > 10) {
        wateringAdvice = "No watering needed today. Rain is expected.";
      } else if (precipitation > 0 && precipitation <= 10) {
        wateringAdvice = "Light watering may be sufficient today.";
      } else {
        wateringAdvice = "Adequate watering is recommended today.";
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Watering Advisory',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              wateringAdvice,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
