import 'package:farmerbuddy/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/npk_provider.dart';
import '../widgets/npk_card.dart';
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
        child: Column(
          children: [
            Consumer<NPKProvider>(
              builder: (ctx, provider, _) {
                if (provider.nValues.isEmpty ||
                    provider.pValues.isEmpty ||
                    provider.kValues.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Fetching NPK data... Please wait."),
                    ),
                  );
                }
                return Column(
                  children: [
                    NPKCard(
                      title: 'Nitrogen (N)',
                      value: provider.nValues.last,
                      unit: 'mg/kg',
                      description:
                          'Essential for plant growth and photosynthesis.',
                      backgroundImage: 'assets/nitrogen_bg.jpg',
                    ),
                    const SizedBox(height: 10),
                    NPKCard(
                      title: 'Phosphorus (P)',
                      value: provider.pValues.last,
                      unit: 'mg/kg',
                      description: 'Promotes root development and flowering.',
                      backgroundImage: 'assets/phosphorus_bg.jpg',
                    ),
                    const SizedBox(height: 10),
                    NPKCard(
                      title: 'Potassium (K)',
                      value: provider.kValues.last,
                      unit: 'mg/kg',
                      description:
                          'Helps regulate water and nutrient movement.',
                      backgroundImage: 'assets/potassium_bg.jpg',
                    ),
                  ],
                );
              },
            ),
            WeatherBanner(),
          ],
        ),
      ),
    );
  }
}
