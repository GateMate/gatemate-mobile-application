import 'package:flutter/material.dart';

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

  // return ChangeNotifierProvider(
  //   create: (context) => AppState(),
  //   child: MaterialApp(
  //     title: 'GateMate Demo',
  //     theme: ThemeData(
  //       primarySwatch: Colors.lightGreen,
  //     ),
  //     home: const HomePage(title: 'GateMate Home Page'),
  //   ),
  // );
}

class AppState extends ChangeNotifier {
  // TODO: Remove this; it is just an example counter generated with the project
  var exampleCounter = 0;
  void incrementCounter() {
    exampleCounter++;
    notifyListeners();
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
  // Index of the page the user has chosen to navigate to
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var incrementCounter = context.watch<AppState>().incrementCounter;

    // Widget pageBody;
    // switch (selectedIndex) {
    //   case 0:
    //     pageBody = ExampleCounterPage();
    //     break;
    //   default:
    //     throw UnimplementedError(
    //         'No widget implemented for index $selectedIndex!');
    // }

    return Scaffold(
      // TODO: AppBar is currently the same for every page; probably want to change
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('My Page!'),
      ),
      drawer: Drawer(
          child: ListView(
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
            title: const Text('Action Center'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ActionCenterRoute()),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Add Gate'),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddGateRoute()),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsRoute()),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
        ],
      )),
      // TODO: FAB is chilling on every page
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

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
// class ExampleCounterPage extends StatelessWidget {
//   const ExampleCounterPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // var count = context.watch<AppState>().exampleCounter;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           const Text(
//             'You have pushed the button this many times:',
//           ),
//           // Text(
//           //   // '$count',
//           //   style: Theme.of(context).textTheme.headline4,
//           // ),
//         ],
//       ),
//     );
//   }
// }
