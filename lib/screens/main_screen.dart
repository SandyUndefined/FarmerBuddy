import 'package:farmerbuddy/app_colors.dart';
import 'package:farmerbuddy/screens/user_setting_screen.dart';
import 'package:farmerbuddy/utils/location_helper.dart';
import 'package:farmerbuddy/widgets/custom_app_bar.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
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
  late Future<String> _locationFuture;

  final List<Widget> _screens = [
    HomeScreen(),
    ImageAnalysisScreen(),
    AdvisoryScreen(),
    UserSettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _locationFuture = LocationHelper.getCurrentLocation();
  }

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
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: FutureBuilder<String>(
          future: _locationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomAppBar(location: 'Fetching...');
            } else if (snapshot.hasError) {
              return CustomAppBar(location: 'Error Fetching Location');
            } else {
              return CustomAppBar(
                  location: snapshot.data ?? 'Unknown Location');
            }
          },
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        animationCurve: Curves.easeInOut,
        onItemSelected: _onTabTapped,
        backgroundColor: AppColors.background,
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.secondary,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.camera),
            title: const Text('Analyze'),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.secondary,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.info),
            title: const Text('Advisory'),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.secondary,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
