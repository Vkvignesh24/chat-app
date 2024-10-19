import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../utils/app_color.dart'; // Import AppColors for consistent color scheme

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(); // For name input

  void _signUp() async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the new user
      User? user = userCredential.user;

      if (user != null) {
        // Create a new user model to save in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': _nameController.text.trim(), // Get name from controller
          'profilePictureUrl': '', // Add profile URL if necessary
        });

        // After successful sign up, navigate back to sign-in screen
        Navigator.pop(context); // Navigate back to sign-in screen
      }
    } catch (e) {
      print(e); // Handle errors
      // You can add error handling logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: AppColors.primaryTextColor)), // Set app bar text color
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
              'Create an Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor, // Set text color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController, // Added name input
              decoration: InputDecoration(
                labelText: 'Name',
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
              onPressed: _signUp,
              child: Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.buttonTextColor, backgroundColor: AppColors.buttonBackgroundColor, // Button text color
                padding: EdgeInsets.symmetric(vertical: 16), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
