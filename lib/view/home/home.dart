import 'package:flutter/material.dart';
import 'package:gatemate_mobile/model/viewmodels/fields_view_model.dart';
import 'package:gatemate_mobile/view/action_center/action_center_view.dart';
import 'package:gatemate_mobile/view/add_gate/add_gate_view.dart';
import 'package:gatemate_mobile/view/gate_management/gate_management_view.dart';
import 'package:gatemate_mobile/view/login/login.dart';
import 'package:gatemate_mobile/view/settings/settings_view.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../model/firebase/gatemate_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            builder: (context) => const LoginPage(),
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
                  builder: (context) => const ActionCenterRoute(),
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
                  builder: (context) => const AddGateRoute(),
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
                  builder: (context) => const GateManagementRoute(),
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
                  builder: (context) => const SettingsRoute(),
                ),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}

class FieldSelectionDropdown extends StatelessWidget {
  const FieldSelectionDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var fieldsViewModel = context.watch<FieldsViewModel>();

    return DropdownButton<String>(
      value: fieldsViewModel.currentFieldSelection,
      items: _mapSetToDropdownMenu(fieldsViewModel.fieldNamesPlaceholder),
      onChanged: (String? value) {
        if (value != null) {
          fieldsViewModel.selectField(value);
        }
      },
      iconSize: 28,
      underline: Container(
        height: 2,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

List<DropdownMenuItem<String>> _mapSetToDropdownMenu(Set<String> items) {
  return items.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
}
