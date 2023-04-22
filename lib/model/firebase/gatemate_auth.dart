import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GateMateAuth extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  User? currentUser;

  GateMateAuth() {
    // Listen for changes in auth state (whether user is logged in)
    _firebaseAuth.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  /// Attempts to sign in to Firestore with `email` and `password`.
  /// Returns `true` and an empty string if and only if the sign in was
  /// successful. Else, returns `false` and an error message if there was
  /// an authorization error from Firebase.
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AuthResponse(true, '');
    } on FirebaseAuthException catch (e) {
      return AuthResponse(false, e.code);
    }
  }

  /// Attempts to create a new Firestore account with `email` and `password`.
  /// Returns `true` and an empty string if and only if the sign up was
  /// successful. Else, returns `false` and an error message if there was
  /// an error from Firebase.
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AuthResponse(true, '');
    } on FirebaseAuthException catch (e) {
      return AuthResponse(false, e.code);
    }
  }

  void signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Returns Firebase authorization token. App server can identify a user with this.
  /// Throws a `GateMateAuthException` if no user is signed in.
  Future<String> getAuthToken() async {
    final userSnapshot = currentUser;
    if (userSnapshot == null) {
      const errorMessage = 'No user signed in! \'currentUser\' is null!';
      Logger().e(errorMessage);
      throw const GateMateAuthException(errorMessage);
    }
    // userSnapshot.getIdToken().then((value) => print(value));

    return userSnapshot.getIdToken();
  }
}

void signUpUser(String token) async {
  var response = await http
      .post(Uri.parse('https://todo-proukhgi3a-uc.a.run.app/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{"auth_token": token}))
      .then((value) => print(value.body));
}

/// Contains information on the status of a completed Firestore authentication
/// request. `successful` is true if and only if there was no
/// FirebaseAuthException. `message` should contain the raw error message from
/// Firebase or the empty string if there was no error.
class AuthResponse {
  final bool successful;
  final String message;

  AuthResponse(this.successful, this.message);
}

class GateMateAuthException implements Exception {
  final String message;

  const GateMateAuthException(this.message);
}
