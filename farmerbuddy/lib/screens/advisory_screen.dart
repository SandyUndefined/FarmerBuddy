import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/npk_provider.dart';
import '../providers/weather_provider.dart';
import '../providers/user_settings_provider.dart';
import '../core/services/openai_service.dart';
import 'advisory_detail_screen.dart';

class AdvisoryScreen extends StatefulWidget {
  @override
  _AdvisoryScreenState createState() => _AdvisoryScreenState();
}

class _AdvisoryScreenState extends State<AdvisoryScreen> {
  String _soilHealthReport = "Loading...";
  String _wateringAdvisoryReport = "Loading...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateReports();
  }

  Future<void> _generateReports() async {
    final npkProvider = Provider.of<NPKProvider>(context, listen: false);
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final userSettingsProvider =
        Provider.of<UserSettingsProvider>(context, listen: false);

    final soilHealthData = {
      "n": npkProvider.nValues.isNotEmpty ? npkProvider.nValues.last : 0,
      "p": npkProvider.pValues.isNotEmpty ? npkProvider.pValues.last : 0,
      "k": npkProvider.kValues.isNotEmpty ? npkProvider.kValues.last : 0,
      "temperature": weatherProvider.dailyWeather.isNotEmpty
          ? weatherProvider.dailyWeather[0]['temp']
          : "N/A",
      "humidity": weatherProvider.dailyWeather.isNotEmpty
          ? weatherProvider.dailyWeather[0]['humidity']
          : "N/A",
      "soilMoisture": 50, // Example or fetched value
    };

    final selectedDate = userSettingsProvider.userSettings.cropDate != null
        ? userSettingsProvider.userSettings.cropDate!
            .toLocal()
            .toString()
            .split(' ')[0]
        : "N/A";

    try {
      final openAIService = OpenAIService();
      final soilHealth =
          await openAIService.getSoilHealthReport(soilHealthData);
      final wateringAdvisory = await openAIService.getWateringAdvisoryReport(
          soilHealthData, selectedDate);

      setState(() {
        _soilHealthReport = soilHealth;
        _wateringAdvisoryReport = wateringAdvisory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _soilHealthReport = "Error generating soil health report: $e";
        _wateringAdvisoryReport =
            "Error generating watering advisory report: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildAnimatedCard(
                    context,
                    title: "Soil Health Report",
                    content: _soilHealthReport,
                    backgroundImage: "assets/soil_health_bg.jpg",
                  ),
                  const SizedBox(height: 16),
                  _buildAnimatedCard(
                    context,
                    title: "Watering Advisory Report",
                    content: _wateringAdvisoryReport,
                    backgroundImage: "assets/watering_advisory_bg.jpg",
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context,
      {required String title,
      required String content,
      required String backgroundImage}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AdvisoryDetailScreen(title: title, content: content),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              content.length > 100
                  ? '${content.substring(0, 100)}...' // Truncated preview
                  : content,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap to read more",
              style: TextStyle(fontSize: 14, color: Colors.lightBlue),
            ),
          ],
        ),
      ),
    );
  }
}
