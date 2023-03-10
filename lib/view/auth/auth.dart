import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gatemate_mobile/view/home/home.dart';
import 'package:gatemate_mobile/view/login/login.dart';
import 'package:gatemate_mobile/main.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage(
              title: 'GateMate',
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
