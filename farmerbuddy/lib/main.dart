import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/npk_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NPKProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: FarmerBuddyApp(),
    ),
  );
}

class FarmerBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmerBuddy',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}
