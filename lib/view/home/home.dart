import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/view/action_center/action_center_view.dart';
import 'package:gatemate_mobile/view/add_gate/add_gate_view.dart';
import 'package:gatemate_mobile/view/gate_management/gate_management_view.dart';
import 'package:gatemate_mobile/view/login/login.dart';
import 'package:gatemate_mobile/view/manage_multiple_gates/manage_multiple_gates.dart';
import 'package:gatemate_mobile/view/settings/settings_view.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import '../../model/firebase/gatemate_auth.dart';
import '../settings/field_selection_row.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GateMate Home'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _authProvider.signOut,
              child: const Text('Sign Out'),
            ),
          ),
          const SizedBox(width: 10),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Workmanager().registerOneOffTask(
                  'field-2',
                  'weather-fetching-test-task',
                  inputData: {
                    'latitude': 8.0,
                    'longitude': 170.1,
                  },
                );
              },
              child: const Text('Notification Test'),
            ),
          ),
        ],
      ),
      drawer: const Drawer(
        child: NavigationDrawer(),
      ),
    );
  }

  void _checkLoginStatus() {
    // TODO: Ensure 'null' is the correct thing to check for
    if (_authProvider.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
        );
      });
    } else {
      // TODO: Either do something here or remove "else"
    }
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // TODO: Should not be creating a new instance of viewmodel here
      // TODO: Use GetIt
      create: (context) => FieldsViewModel(),
      child: _drawer(context),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            // TODO: Populate with data from Firebase authentication
            accountName: const Text("xyz"),
            accountEmail: const Text("xyz@gmail.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("xyz"),
            ),
          ),
          const Text(
            'Current Field Selection: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const FieldSelectionDropdown(),
          Divider(
            color: Colors.green[700],
            thickness: 2.0,
          ),
          ListTile(
            title: const Text('Action Center'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActionCenterView(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Add Gate'),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddGateView(),
                ),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Gate Management'),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GateManagementRoute(),
                ),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Manage Multiple Gates'),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultipleGateManagementRoute()),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          // ListTile(
          //   title: const Text('Add Field'),
          //   onTap: () {
          //     // Update the state of the app
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const AddFieldRoute()),
          //     );
          //     // Then close the drawer
          //     // Navigator.pop(context);
          //   },
          //   trailing: const Icon(Icons.arrow_forward_ios),
          // ),
        ],
      ),
    );
  }
}

