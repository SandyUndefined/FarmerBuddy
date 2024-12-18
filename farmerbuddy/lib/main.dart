import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'providers/npk_provider.dart';
import 'providers/weather_provider.dart';

void main() {
  runApp(FarmerBuddyApp());
}

class FarmerBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NPKProvider()),
        ChangeNotifierProvider(
            create: (_) => WeatherProvider()), // Add WeatherProvider
      ],
      child: MaterialApp(
        title: 'FarmerBuddy',
        theme: ThemeData(primarySwatch: Colors.green),
        home: MainScreen(),
      ),
    );
  }
}
