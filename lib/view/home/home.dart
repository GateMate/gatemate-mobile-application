import 'package:flutter/material.dart';
import 'package:gatemate_mobile/view/action_center/action_center_view.dart';
import 'package:gatemate_mobile/view/add_gate/add_gate_view.dart';
import 'package:gatemate_mobile/view/gate_management/gate_management_view.dart';
import 'package:gatemate_mobile/model/fields_view_model.dart';
import 'package:gatemate_mobile/view/settings/settings_view.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Placeholder(), // TODO
      drawer: const Drawer(
        child: NavigationDrawer(),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
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
