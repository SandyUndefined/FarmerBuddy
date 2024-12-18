import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String location; // Current location to display

  CustomAppBar({required this.location});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Farmer Buddy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.highlighter),
              SizedBox(width: 5),
              Text(
                location,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
