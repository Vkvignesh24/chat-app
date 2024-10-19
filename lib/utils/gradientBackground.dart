import 'package:flutter/material.dart';
import 'app_color.dart';

class GradientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            'Hello with Gradient Background!',
            style: TextStyle(
              fontSize: 24,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
