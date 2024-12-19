import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, _) {
        final dailyWeather = weatherProvider.dailyWeather;

        if (dailyWeather.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Fetching weather data... Please wait.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          );
        }

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    '7-Day Weather Forecast',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                     itemCount: dailyWeather.length,
                    itemBuilder: (context, index) {
                      final day = dailyWeather[index];
                      final date = day['date'];
                      final temp = day['temp'];
                      final condition = day['condition'];
                      final icon = _getWeatherIcon(condition);

                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.withOpacity(0.1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              icon,
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$temp°C',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              condition,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'assets/sunny.png';
      case 'rain':
        return 'assets/rainy.png';
      case 'clouds':
        return 'assets/cloudy.png';
      case 'snow':
        return 'assets/snowy.png';
      default:
        return 'assets/default_weather.png';
    }
  }
}
