import 'package:flutter/material.dart';
import '../utils/app_color.dart'; // Import AppColors

class MyProfile extends StatelessWidget {
  final String name;
  final String email;

  MyProfile({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: AppColors.primaryTextColor)), // Set app bar text color
        backgroundColor: AppColors.appBarColor, // Set app bar background color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor, // Set text color
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor, // Set text color
              ),
            ),
            // Add more details if needed (like profile picture, phone number, etc.)
          ],
        ),
      ),
    );
  }
}
