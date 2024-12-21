import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:farmerbuddy/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Navigate to MainScreen

class AppIntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Monitor Your Crops",
          body:
              "Get real-time insights about Temperature, Humidity, Moisture, and NPK levels in your fields.",
          image: _buildImage('assets/intro_monitor.png'),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Weather Forecast",
          body:
              "Plan ahead with accurate 7-day weather forecasts tailored to your location.",
          image: _buildImage('assets/intro_weather.jpg'),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "Get Expert Advice",
          body:
              "Receive tailored soil health reports, watering advisories, and crop recommendations.",
          image: _buildImage('assets/intro_advice.png'),
          decoration: _pageDecoration(),
        ),
      ],
      onDone: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('introduction_seen', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      },
      onSkip: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('introduction_seen', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildImage(String assetName) {
    return Center(
      child: Image.asset(
        assetName,
        width: 300.0,
      ),
    );
  }

  PageDecoration _pageDecoration() {
    return const PageDecoration(
      titleTextStyle:
          TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 16.0),
      imagePadding: EdgeInsets.only(top: 40.0),
      pageColor: Colors.white,
    );
  }
}
