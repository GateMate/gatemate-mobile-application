import 'dart:convert';
import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(flex: 2),
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Log In',
                      style: TextStyle(fontSize: 40),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 20, 0, 20),
                      child: LoginMenu(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginMenu extends StatefulWidget {
  const LoginMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginMenu> createState() => _LoginMenuState();
}

class _LoginMenuState extends State<LoginMenu> {
  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  // TODO: Move these firebase things to a viewmodel

  // Firebase Authentication
  final _firebaseAuth = FirebaseAuth.instance;
  User? get _currentUser => _firebaseAuth.currentUser;
  Stream<User?> get _authStateChanges => _firebaseAuth.authStateChanges();
  var _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _emailInputController,
          decoration: InputDecoration(
            hintText: 'user@email.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: const Icon(Icons.mail_outline),
          ),
          onChanged: _validateEmail,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            _errorMessage,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Password',
          style: TextStyle(fontSize: 18),
        ),
        TextField(
          controller: _passwordInputController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '* * * * * * * * * *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: const Icon(Icons.key),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: _signIn,
                  child: const Text('Log In'),
                ),
              ),
              const Spacer(flex: 2),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Gets called when a user signs in
  void _signIn() async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailInputController.text,
        password: _passwordInputController.text,
      );
      // TODO: Implement service call to signin route with the currentUser
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(e.code);
    }
  }

  // Gets called when the user signs up (happens when you click sign up)
  void _signUp() async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailInputController.text,
        password: _passwordInputController.text,
      );

      /* Id will be passed into a service call to the server api and
       * stored as a collection.
       */
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(e.code);
    }
  }

  // Call this with a sign out button
  void _signOut() async {
    await _firebaseAuth.signOut();
  }

  // Network service call to create and log userID - still working on this - unknown network error with local url-TODO
  Future<http.Response> _createUser(String? userId) {
    log("MAKING HTTP REQUEST");
    return http.post(
      Uri.parse('http://127.0.0.1:5000/siginin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String?>{
          'user': userId,
        },
      ),
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  void _validateEmail(String email) {
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Email cannot be empty!';
      });
    } else if (!EmailValidator.validate(email, true)) {
      setState(() {
        _errorMessage = 'Invalid email address!';
      });
    } else {
      setState(() {
        _errorMessage = '';
      });
    }
  }
}
