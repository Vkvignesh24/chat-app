import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:pro_chat/screens/chat_screen.dart'; // Import ChatScreen
import 'package:pro_chat/screens/settings_page.dart'; // Import SettingsScreen
import '../models/user_model.dart';
import '../utils/app_color.dart'; // Import AppColors
import 'package:image_picker/image_picker.dart'; // Import image_picker

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  final UserModel userModel;

  HomeScreen({required this.currentUserId, required this.userModel});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserModel> addedUsers = []; // List to store added users
  final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker

  @override
  void initState() {
    super.initState();
    _fetchAddedUsers(); // Fetch added users when the screen initializes
  }

  // Function to fetch added users from Firestore
  void _fetchAddedUsers() async {
    try {
      // Get the list of user IDs that the current user has added
      DocumentSnapshot connectionsDoc = await _firestore.collection('userConnections').doc(widget.currentUserId).get();

      if (connectionsDoc.exists) {
        List<dynamic> addedUserIds = connectionsDoc['addedUserIds'] ?? [];

        // Fetch details for each added user
        for (String uid in addedUserIds) {
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
          if (userDoc.exists) {
            UserModel user = UserModel(
              uid: userDoc['uid'],
              name: userDoc['name'],
              email: userDoc['email'],
              profilePictureUrl: userDoc['profilePictureUrl'],
            );

            setState(() {
              addedUsers.add(user); // Add to local list
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching added users: $e");
    }
  }

  // Function to handle adding or fetching a user
  void _addUser(BuildContext context) async {
    String? name;
    String? email;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                email = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (email == null || email!.isEmpty) {
                print("Email cannot be empty.");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email cannot be empty.")),
                );
                return;
              }

              try {
                // Check if email exists in Firestore
                QuerySnapshot userQuery = await _firestore.collection('users').where('email', isEqualTo: email).get();

                if (userQuery.docs.isEmpty) {
                  // If the email does not exist, show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Email does not exist.")),
                  );
                  return;
                }

                // If the email exists, create a UserModel
                DocumentSnapshot userDoc = userQuery.docs.first; // Get the first document

                UserModel existingUser = UserModel(
                  uid: userDoc['uid'],
                  name: userDoc['name'],
                  email: userDoc['email'],
                  profilePictureUrl: userDoc['profilePictureUrl'],
                );

                // Update userConnections to include the new user
                await _firestore.collection('userConnections').doc(widget.currentUserId).set({
                  'addedUserIds': FieldValue.arrayUnion([existingUser.uid])
                }, SetOptions(merge: true));

                // Add the existing user to the local list
                setState(() {
                  addedUsers.add(existingUser);
                });

                Navigator.of(context).pop();
              } catch (e) {
                print("Error fetching user: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error fetching user: $e")),
                );
              }
            },
            child: Text('Add User'),
          ),
        ],
      ),
    );
  }

  // Function to open the camera and capture an image
  Future<void> _openCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // Do something with the captured image (e.g., upload to Firestore or display)
        print("Image captured: ${image.path}");
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: AppColors.primaryTextColor)),
        backgroundColor: AppColors.appBarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: AppColors.primaryTextColor),
            onPressed: _openCamera, // Call the function to open the camera
          ),
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.primaryTextColor),
            onPressed: () {
              // Navigate to the SettingsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, ${widget.userModel.name}!',
                    style: TextStyle(fontSize: 24, color: AppColors.primaryTextColor),
                  ),
                  SizedBox(height: 20),
                  Text('This is your home screen.', style: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: addedUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(addedUsers[index].name, style: TextStyle(color: AppColors.primaryTextColor)),
                    onTap: () {
                      // Navigate to the ChatScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: widget.currentUserId,
                            targetUser: addedUsers[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.buttonBackgroundColor,
        onPressed: () => _addUser(context),
        child: Icon(Icons.add, color: AppColors.buttonTextColor),
      ),
    );
  }
}
