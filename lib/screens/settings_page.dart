import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_profile.dart'; // Import the MyProfile screen
import '../utils/app_color.dart'; // Import AppColors

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user from FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: AppColors.primaryTextColor)), // Set app bar text color
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
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person, color: AppColors.primaryTextColor), // Set icon color
              title: Text(
                'My Profile',
                style: TextStyle(color: AppColors.primaryTextColor), // Set text color
              ),
              onTap: () {
                if (user != null) {
                  // Pass the user's name and email to the MyProfile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfile(
                        name: user.displayName ?? 'Unknown User',
                        email: user.email ?? 'No email available',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User not logged in')),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: AppColors.primaryTextColor), // Set icon color
              title: Text(
                'About',
                style: TextStyle(color: AppColors.primaryTextColor), // Set text color
              ),
              onTap: () {
                // Navigate to About Page (Implement this if needed)
              },
            ),
            ListTile(
              leading: Icon(Icons.smart_toy, color: AppColors.primaryTextColor), // Set icon color
              title: Text(
                'AI Bot',
                style: TextStyle(color: AppColors.primaryTextColor), // Set text color
              ),
              onTap: () {
                // Navigate to AI Bot Page (Implement this if needed)
              },
            ),
            Divider(color: AppColors.secondaryTextColor), // Set divider color
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.primaryTextColor), // Set icon color
              title: Text(
                'Logout',
                style: TextStyle(color: AppColors.primaryTextColor), // Set text color
              ),
              onTap: () async {
                // Sign out and navigate back
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst); // Return to the first screen (AuthWrapper)
              },
            ),
          ],
        ),
      ),
    );
  }
}
