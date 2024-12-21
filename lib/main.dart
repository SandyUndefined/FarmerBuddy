import 'package:farmerbuddy/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'screens/introduction_screen.dart'; // Import the introduction screen
import 'providers/npk_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/user_settings_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await dotenv.load(fileName: ".env");
  runApp(FarmerBuddyApp());
}

class FarmerBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NPKProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => UserSettingsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSansDevanagari',
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(
            secondary: AppColors.secondary,
          ),
          scaffoldBackgroundColor: AppColors.background,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            titleLarge: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
            bodyMedium: TextStyle(
              fontSize: 14.0,
              color: AppColors.text,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.background,
              textStyle: const TextStyle(fontSize: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        home:
            AppStartupScreen(), // Updated to show IntroductionScreen or MainScreen
      ),
    );
  }
}

class AppStartupScreen extends StatelessWidget {
  Future<bool> _checkIfIntroductionSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('introduction_seen') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfIntroductionSeen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final seen = snapshot.data ?? false;
        return seen
            ? MainScreen()
            : AppIntroductionScreen(); // Show appropriate screen
      },
    );
  }
}
