import 'package:farmerbuddy/core/services/user_setting_screen.dart';
import 'package:flutter/material.dart';
import 'advisory_screen.dart';
import 'home_screen.dart';
import 'image_analysis_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ImageAnalysisScreen(),
    AdvisoryScreen(),
    UserSettingScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Method to programmatically set the tab index
  void setTabIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.black, // Set selected icon color to black
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Analyze'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Advisory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
