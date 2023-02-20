import 'package:flutter/material.dart';
import 'package:gatemate_mobile/login/login.dart';
import 'package:gatemate_mobile/model/fields_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'action_center/action_center_view.dart' show ActionCenterRoute;
import 'add_gate/add_gate_view.dart' show AddGateRoute;
import 'gate_management/gate_management.dart' show GateManagementRoute;
import 'settings/settings_view.dart' show SettingsRoute;

void main() {
  runApp(const GateMateApp());
}

class GateMateApp extends StatelessWidget {
  const GateMateApp({super.key});
  static const appTitle = 'GateMate App';

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.green[400] ?? Colors.green,
    );

    return MaterialApp(
      title: appTitle,
      home: const LoginPage(),
      theme: ThemeData(
        colorScheme: colorScheme,
        cardTheme: CardTheme(
          color: Colors.lightBlueAccent[100],
          elevation: 2,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.tertiary,
        ),
        backgroundColor: colorScheme.secondaryContainer,
        scaffoldBackgroundColor: colorScheme.secondaryContainer,
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key, required this.title});

//   // Title of the page (displayed in the appbar)
//   final String title;

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: const Placeholder(), // TODO
//       drawer: const Drawer(
//         child: NavigationDrawer(),
//       ),
//     );
//   }
// }

// class NavigationDrawer extends StatelessWidget {
//   const NavigationDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return ListView(
//     //   // Important: Remove any padding from the ListView.
//     //   padding: EdgeInsets.zero,
//     //   children: [
//     //     DrawerHeader(
//     //       decoration: BoxDecoration(
//     //         color: Theme.of(context).colorScheme.primary,
//     //       ),
//     //       child: const Text('Drawer Header'),
//     //     ),
//     //     ListTile(
//     //         title: const Text('Home'),
//     //         onTap: () {
//     //           Navigator.pop(context);
//     //         })
//     //   ],
//     // );
//     return ChangeNotifierProvider(
//         create: (context) => FieldsViewModel(), child: _drawer(context));
//   }

//   Widget _drawer(BuildContext context) {
//     return Drawer(
//       elevation: 16.0,
//       child: Column(
//         children: <Widget>[
//           UserAccountsDrawerHeader(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               accountName: Text("xyz"),
//               accountEmail: Text("xyz@gmail.com"),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Text("xyz"),
//               )),
//           Text('Current Field Selection: ',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           FieldSelectionDropdown(),
//           Divider(
//             color: Colors.green[700],
//             thickness: 2.0,
//           ),
//           ListTile(
//             title: const Text('Action Center'),
//             onTap: () {
//               // Update the state of the app
//               // ...
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const ActionCenterRoute()),
//               );
//             },
//             trailing: new Icon(Icons.arrow_forward_ios),
//           ),
//           ListTile(
//             title: const Text('Add Gate'),
//             onTap: () {
//               // Update the state of the app
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AddGateRoute()),
//               );
//               // Then close the drawer
//               // Navigator.pop(context);
//             },
//             trailing: new Icon(Icons.arrow_forward_ios),
//           ),
//           ListTile(
//             title: const Text('Gate Management'),
//             onTap: () {
//               // Update the state of the app
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => GateManagementRoute()),
//               );
//               // Then close the drawer
//               // Navigator.pop(context);
//             },
//             trailing: new Icon(Icons.arrow_forward_ios),
//           ),
//           ListTile(
//             title: const Text('Settings'),
//             onTap: () {
//               // Update the state of the app
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const SettingsRoute()),
//               );
//               // Then close the drawer
//               // Navigator.pop(context);
//             },
//             trailing: new Icon(Icons.arrow_forward_ios),
//           )
//         ],
//       ),
//     );
//   }
// }

// class FieldSelectionDropdown extends StatelessWidget {
//   const FieldSelectionDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var fieldsViewModel = context.watch<FieldsViewModel>();

//     return DropdownButton<String>(
//       value: fieldsViewModel.currentFieldSelection,
//       items: _mapSetToDropdownMenu(fieldsViewModel.fieldNamesPlaceholder),
//       onChanged: (String? value) {
//         if (value != null) {
//           fieldsViewModel.selectField(value);
//         }
//       },
//       iconSize: 28,
//       underline: Container(
//         height: 2,
//         color: theme.colorScheme.primary,
//       ),
//     );
//   }
// }

// List<DropdownMenuItem<String>> _mapSetToDropdownMenu(Set<String> items) {
//   return items.map<DropdownMenuItem<String>>((String value) {
//     return DropdownMenuItem<String>(
//       value: value,
//       child: Text(value),
//     );
//   }).toList();
// }


  // @override
  // Widget build(BuildContext context) {
  //   return ListView(
  //     // Important: Remove any padding from the ListView.
  //     padding: EdgeInsets.zero,
  //     children: [
  //       const DrawerHeader(
  //         decoration: BoxDecoration(
  //           color: Colors.blue,
  //         ),
  //         child: Text('Drawer Header'),
  //       ),
  //       ListTile(
  //         title: const Text('Home'),
  //         onTap: () {
  //           // Update the state of the app

  //           // Then close the drawer
  //           Navigator.pop(context);
  //         },
  //       ),
  //       ListTile(
  //         title: const Text('Action Center'),
  //         onTap: () {
  //           // Update the state of the app
  //           // ...
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => const ActionCenterRoute()),
  //           );
  //           // Then close the drawer
  //           // Navigator.pop(context);
  //         },
  //       ),
  //       ListTile(
  //         title: const Text('Add Gate'),
  //         onTap: () {
  //           // Update the state of the app
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => AddGateRoute()),
  //           );
  //           // Then close the drawer
  //           // Navigator.pop(context);
  //         },
  //       ),
  //       ListTile(
  //         title: const Text('Settings'),
  //         onTap: () {
  //           // Update the state of the app
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => const SettingsRoute()),
  //           );
  //           // Then close the drawer
  //           // Navigator.pop(context);
  //         },
  //       ),
  //     ],
  //   );
  // }
