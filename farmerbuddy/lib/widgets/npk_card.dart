import 'package:flutter/material.dart';
import '../app_colors.dart';

class NPKCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit; // e.g., "mg/kg"
  final String description; // Description for the nutrient
  final String backgroundImage; // Background image path

  NPKCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.description,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black
                  .withOpacity(0.3), // Add a dark overlay for text readability
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              // Value and Unit
              Row(
                children: [
                  Text(
                    value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.highlighter,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Description
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
