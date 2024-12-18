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

    final temperature = weatherProvider.weatherData.isNotEmpty
        ? weatherProvider.weatherData['list'][0]['main']['temp']
        : 'N/A';

    final humidity = weatherProvider.weatherData.isNotEmpty
        ? weatherProvider.weatherData['list'][0]['main']['humidity']
        : 'N/A';

    final soilMoisture = 50; // Static or fetched from a sensor (example value)

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
            Text('Nitrogen (N): $nValue mg/kg'),
            Text('Phosphorus (P): $pValue mg/kg'),
            Text('Potassium (K): $kValue mg/kg'),
            Text('Temperature: $temperature °C'),
            Text('Humidity: $humidity%'),
            Text('Soil Moisture: $soilMoisture%'),
          ],
        ),
      ),
    );
  }
}
