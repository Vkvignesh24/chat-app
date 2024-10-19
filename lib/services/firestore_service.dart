import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': user.name,
      'email': user.email,
      'profilePictureUrl': user.profilePictureUrl,
    });
  }
  // Function to fetch users from Firestore

}
