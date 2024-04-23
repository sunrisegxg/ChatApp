import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      //sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password
      );

      // //save user info if it doesn't already exist
      // await _firestore.collection("users").doc(userCredential.user!.uid).set(
      //   {
      //     'uid': userCredential.user!.uid,
      //     'email': email,
      //   }
      // );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, String firstName, String lastName, String age, String phoneNumber, String job, String bio, String avatar) async {
    try {
      //create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
      );
      // if (email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty || age.isEmpty) {
      //   throw Exception('Please fill in all required fields');
      // }
      //save user info in a separate doc
      await _firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'first name': firstName,
          'last name': lastName,
          'age': age,
          'phone number': phoneNumber,
          'job' : job,
          'bio': bio,
          'avatar': avatar,
        }
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
  //errors
}