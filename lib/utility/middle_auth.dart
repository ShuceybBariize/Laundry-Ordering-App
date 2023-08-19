// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user !=
          null; // Return true if the user is not null (login successful).
    } catch (e) {
      print('Error signing in: $e');
      return false; // Return false if there's an error (login failed).
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    return user !=
        null; // Return true if the user is logged in, false otherwise.
  }

  Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }

  Future<String?> getUserRole(String userEmail) async {
    // Assume you have a 'users' collection in Firestore and each user document has an 'email' field.
    // Replace 'users' with your actual collection name and 'email' with the field containing user email.
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first);

    if (snapshot.exists) {
      return snapshot.data()?['role'];
    }
    return null;
  }
}
