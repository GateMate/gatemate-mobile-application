import 'package:flutter/material.dart';

class AddGateRoute extends StatelessWidget {
  const AddGateRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gate'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('adding a gate'),
        ),
      ),
    );
  }
}
