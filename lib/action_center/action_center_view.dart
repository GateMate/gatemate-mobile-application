import 'package:flutter/material.dart';

class ActionCenterRoute extends StatelessWidget {
  const ActionCenterRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Center'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Action center'),
        ),
      ),
    );
  }
}
