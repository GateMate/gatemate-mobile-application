import 'package:flutter/material.dart';

import 'action_center/action_center_view.dart' show ActionCenterRoute;
import 'add_gate/add_gate_view.dart' show AddGateRoute;
import 'settings/settings_view.dart' show SettingsRoute;
import 'gate_management/gate_management_view.dart' show GateManagementRoute;

void main() {
  runApp(const GateMateApp());
}

class GateMateApp extends StatelessWidget {
  const GateMateApp({super.key});
  static const appTitle = 'GateMate App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: HomePage(title: appTitle),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // Title of the page (displayed in the appbar)
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Placeholder(), // TODO
      drawer: Drawer(
        child: NavigationDrawer(),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Drawer Header'),
        ),
        ListTile(
          title: const Text('Home'),
          onTap: () {
            // Update the state of the app

            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Gate Management'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GateManagementRoute()),
            );
            // Then close the drawer
            // Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Action Center'),
          onTap: () {
            // Update the state of the app
            // ...
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActionCenterRoute()),
            );
            // Then close the drawer
            // Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Add Gate'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddGateRoute()),
            );
            // Then close the drawer
            // Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsRoute()),
            );
            // Then close the drawer
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
