import 'package:farmerbuddy/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 150,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
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
                  return Column(
                    children: List.generate(4, (_) => _buildShimmerCard()),
                  );
                }
                return Column(
                  children: [
                    CustomCard(
                      title: 'Temperature',
                      value: provider.temperature.last,
                      unit: '°C',
                      description: 'Field temperature measured in real-time.',
                      backgroundImage: 'assets/temperature_bg.jpg',
                    ),
                    CustomCard(
                      title: 'Humidity',
                      value: provider.humidity.last,
                      unit: '%',
                      description: 'Field humidity measured in real-time.',
                      backgroundImage: 'assets/humidity_bg.jpg',
                    ),
                    CustomCard(
                      title: 'Moisture',
                      value: provider.moisture.last,
                      unit: '%',
                      description: 'Soil moisture content.',
                      backgroundImage: 'assets/moisture_bg.png',
                    ),
                    CustomCard(
                      title: 'NPK',
                      value:
                          '${provider.nValues.last}N, ${provider.pValues.last}P, ${provider.kValues.last}K',
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
