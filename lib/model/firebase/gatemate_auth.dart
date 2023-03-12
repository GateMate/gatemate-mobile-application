import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/pair.dart';

class GateMateAuth extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  User? get _currentUser => _firebaseAuth.currentUser;
  Stream<User?> get _authStateChanges => _firebaseAuth.authStateChanges();

  /// Attempts to sign in to Firestore with `email` and `password`.
  /// Returns `true` and an empty string if and only if the sign in was
  /// successful. Else, returns `false` and an error message if there was
  /// an authorization error from Firebase.
  Future<Pair<bool, String>> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // TODO: Implement service call to signin route with the currentUser -JM

      return Pair(true, '');
    } on FirebaseAuthException catch (e) {
      return Pair(false, e.code);
    }
  }

  /// Attempts to create a new Firestore account with `email` and `password`.
  /// Returns `true` and an empty string if and only if the sign up was
  /// successful. Else, returns `false` and an error message if there was
  /// an error from Firebase.
  Future<Pair<bool, String>> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password,);

      /* TODO
       * Id will be passed into a service call to the server api and
       * stored as a collection. -JM
      */

      return Pair(true, '');
    } on FirebaseAuthException catch (e) {
      return Pair(false, e.code);
    }
  }

  // TODO: signOut

  // TODO: createUser (?)
}
