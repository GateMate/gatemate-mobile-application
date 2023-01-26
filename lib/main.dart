import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const GateMateApp());
}

class GateMateApp extends StatelessWidget {
  const GateMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'GateMate Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const HomePage(title: 'GateMate Home Page'),
      ),
    );
  }
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
    var incrementCounter = context.watch<AppState>().incrementCounter;

    Widget pageBody;
    switch (selectedIndex) {
      case 0:
        pageBody = ExampleCounterPage();
        break;
      default:
        throw UnimplementedError('No widget implemented for index $selectedIndex!');
    }

    return Scaffold(
      // TODO: AppBar is currently the same for every page; probably want to change
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: pageBody,
      // TODO: FAB is chilling on every page
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExampleCounterPage extends StatelessWidget {
  const ExampleCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var count = context.watch<AppState>().exampleCounter;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$count',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}