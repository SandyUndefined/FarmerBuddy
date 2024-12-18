import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/npk_provider.dart';
import '../widgets/npk_card.dart';
import '../widgets/weather_banner.dart';

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
      // Handle errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });
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
                    ),
                    NPKCard(
                      title: 'Phosphorus (P)',
                      value: provider.pValues.last,
                    ),
                    NPKCard(
                      title: 'Potassium (K)',
                      value: provider.kValues.last,
                    ),
                  ],
                );
              },
            ),
            WeatherBanner(), // Add weather banner widget
          ],
        ),
      ),
    );
  }
}
