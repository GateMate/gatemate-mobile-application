import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gatemate_mobile/view/home/home.dart';
import 'package:gatemate_mobile/view/ui_primatives/custom_input_field.dart';
import 'package:get_it/get_it.dart';

import '../../model/firebase/gatemate_auth.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                      child: _LoginMenu(),
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

class _LoginMenu extends StatefulWidget {
  const _LoginMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<_LoginMenu> createState() => _LoginMenuState();
}

class _LoginMenuState extends State<_LoginMenu> {
  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();
  var _emailInputErrorMessage = "";

  final _authProvider = GetIt.I<GateMateAuth>();

  @override
  void initState() {
    super.initState();

    // Manually check login status because the below listener will only trigger
    // upon a change in status, which may not occur when this widget is
    // initialized.
    _checkLoginStatus();
    _authProvider.addListener(_checkLoginStatus);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_checkLoginStatus);
    _emailInputController.dispose();
    _passwordInputController.dispose();

    super.dispose();
  }

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
        // TODO: Utilize `CustomInputField` once it can use `onChanged`
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
            _emailInputErrorMessage,
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
        const SizedBox(height: 10),
        CustomInputField(
          inputController: _passwordInputController,
          hintText: '* * * * * * * * * *',
          obscureText: true,
          prefixIcon: const Icon(Icons.key),
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

  /// Sign in through authorization provider
  void _signIn() async {
    var response = await _authProvider.signIn(
      _emailInputController.text,
      _passwordInputController.text,
    );

    // Successful sign-ins are handled by listening to changes in the
    // AuthProvider, so we only handle errors here.
    if (!response.successful) {
      // TODO: Beautify message
      _showErrorMessage(response.message);
    }
  }

  // Sign up through the authorization provider
  void _signUp() async {
    var response = await _authProvider.signUp(
      _emailInputController.text,
      _passwordInputController.text,
    );

    // Successful sign-ins are handled by listening to changes in the
    // AuthProvider, so we only handle errors here.
    if (!response.successful) {
      // TODO: Beautify message
      _showErrorMessage(response.message);
    }
  }

  void _checkLoginStatus() {
    if (_authProvider.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      });
    }
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
        _emailInputErrorMessage = 'Email cannot be empty!';
      });
    } else if (!EmailValidator.validate(email, true)) {
      setState(() {
        _emailInputErrorMessage = 'Invalid email address!';
      });
    } else {
      setState(() {
        _emailInputErrorMessage = '';
      });
    }
  }
}
