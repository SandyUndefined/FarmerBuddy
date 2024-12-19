import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/npk_provider.dart';
import '../providers/weather_provider.dart';

class SoilHealthCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final npkProvider = Provider.of<NPKProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);

    final nValue =
        npkProvider.nValues.isNotEmpty ? npkProvider.nValues.last : 0;
    final pValue =
        npkProvider.pValues.isNotEmpty ? npkProvider.pValues.last : 0;
    final kValue =
        npkProvider.kValues.isNotEmpty ? npkProvider.kValues.last : 0;

    final weather = weatherProvider.dailyWeather.isNotEmpty
        ? weatherProvider.dailyWeather[0]
        : null;

    final temperature = weather != null ? '${weather['temp']} °C' : 'N/A';
    final humidity = weather != null ? '${weather['humidity']}%' : 'N/A';

    final soilMoisture = 50; // Example value or sensor integration

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Soil Health Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Nitrogen (N): $nValue mg/kg',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Phosphorus (P): $pValue mg/kg',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Potassium (K): $kValue mg/kg',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Temperature: $temperature',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Humidity: $humidity',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Soil Moisture: $soilMoisture%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
