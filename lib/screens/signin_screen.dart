import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart'; // Import the SignUpScreen
import '../utils/app_color.dart'; // Import AppColors for consistent color scheme

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // On success, the user will be directed to HomeScreen by AuthWrapper.
    } catch (e) {
      print(e); // Handle errors (You can add a dialog or snackbar for error display)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In', style: TextStyle(color: AppColors.primaryTextColor)), // Set app bar text color
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50), // Spacer for better top padding
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor, // Set text color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: AppColors.secondaryTextColor), // Set label color
                filled: true,
                fillColor: Colors.white, // Background color of the text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Padding inside the text field
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: AppColors.secondaryTextColor), // Set label color
                filled: true,
                fillColor: Colors.white, // Background color of the text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Padding inside the text field
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.buttonTextColor, backgroundColor: AppColors.buttonBackgroundColor, // Button text color
                padding: EdgeInsets.symmetric(vertical: 16), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to the SignUpScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: AppColors.buttonTextColor), // Set text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
