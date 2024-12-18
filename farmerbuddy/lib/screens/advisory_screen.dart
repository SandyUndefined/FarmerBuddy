import 'package:flutter/material.dart';
import '../widgets/soil_health_card.dart';
import '../widgets/watering_advisory_card.dart';

class AdvisoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advisory')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SoilHealthCard(), // Soil health card widget
            SizedBox(height: 20), // Spacing
            WateringAdvisoryCard() // Watering advisory card widget
          ],
        ),
      ),
    );
  }
}
