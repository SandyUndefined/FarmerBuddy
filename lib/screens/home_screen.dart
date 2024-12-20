import 'package:farmerbuddy/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/npk_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/weather_banner.dart';
import '../utils/location_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final npkProvider = Provider.of<NPKProvider>(context, listen: false);
    npkProvider.fetchNPKData(context).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });

    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      final location = await LocationHelper.getCurrentLocationCoordinates();
      await weatherProvider.fetchWeather(location.latitude, location.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching weather data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<NPKProvider>(
              builder: (ctx, provider, _) {
                if (provider.temperature.isEmpty ||
                    provider.humidity.isEmpty ||
                    provider.moisture.isEmpty ||
                    provider.nValues.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Fetching field data... Please wait."),
                    ),
                  );
                }
                return Column(
                  children: [
                    CustomCard(
                      title: 'Temperature',
                      value: provider.temperature.isNotEmpty
                          ? provider.temperature.last
                          : 'N/A',
                      unit: '°C',
                      description: 'Field temperature measured in real-time.',
                      backgroundImage: 'assets/temperature_bg.jpg',
                    ),
                    CustomCard(
                      title: 'Humidity',
                      value: provider.humidity.isNotEmpty
                          ? provider.humidity.last
                          : 'N/A',
                      unit: '%',
                      description: 'Field humidity measured in real-time.',
                      backgroundImage: 'assets/humidity_bg.jpg',
                    ),
                    CustomCard(
                      title: 'Moisture',
                      value: provider.moisture.isNotEmpty
                          ? provider.moisture.last
                          : 'N/A',
                      unit: '%',
                      description: 'Soil moisture content.',
                      backgroundImage: 'assets/moisture_bg.png',
                    ),
                    CustomCard(
                      title: 'NPK',
                      value: provider.nValues.isNotEmpty &&
                              provider.pValues.isNotEmpty &&
                              provider.kValues.isNotEmpty
                          ? '${provider.nValues.last}N, ${provider.pValues.last}P, ${provider.kValues.last}K'
                          : 'N/A',
                      unit: '',
                      description: 'NPK levels in the soil.',
                      backgroundImage: 'assets/npk_bg.jpg',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            WeatherBanner(),
          ],
        ),
      ),
    );
  }
}
