import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/signin_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_model.dart'; // Adjust the path according to your file structure.
import 'utils/app_color.dart'; // Import AppColors

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Chat',
      theme: ThemeData(
        // Apply AppColors to the app theme
        primaryColor: AppColors.gradientStart,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.primaryTextColor),
          bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.appBarColor,
          titleTextStyle: TextStyle(color: AppColors.primaryTextColor, fontSize: 20),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.buttonBackgroundColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: AuthWrapper(), // A wrapper to manage the auth state.
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If user is signed in, go to HomeScreen, otherwise show SignInScreen.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator while waiting for auth state.
        } else if (snapshot.hasData) {
          // User is signed in, create a UserModel instance with the necessary data.
          User? firebaseUser = snapshot.data;

          UserModel userModel = UserModel(
            uid: firebaseUser!.uid, // Required uid
            name: firebaseUser.displayName ?? 'User', // Use displayName, fallback to 'User'
            email: firebaseUser.email ?? 'No Email', // Required email
            profilePictureUrl: firebaseUser.photoURL ?? '', // Profile picture URL, fallback to empty string
          );

          return HomeScreen(
            currentUserId: firebaseUser.uid,
            userModel: userModel,
          ); // Pass UserModel to HomeScreen.
        } else {
          // User is not signed in.
          return SignInScreen();
        }
      },
    );
  }
}
