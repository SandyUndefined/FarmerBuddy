import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherBanner extends StatefulWidget {
  @override
  _WeatherBannerState createState() => _WeatherBannerState();
}

class _WeatherBannerState extends State<WeatherBanner> {
  @override
  void initState() {
    super.initState();
    // Dummy coordinates for example (replace with real location fetch logic)
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    weatherProvider.fetchWeather(20.2961, 85.8245); // Coordinates for Bhubaneswar
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        if (provider.weatherData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final forecastList = provider.weatherData['list'];
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "7-Day Weather Forecast",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final day = forecastList[index];
                    final temperature = day['main']['temp'];
                    final date = DateTime.parse(day['dt_txt']);
                    return Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${date.day}/${date.month}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.wb_sunny, size: 30), // Dummy icon
                          Text("$temperature°C"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
