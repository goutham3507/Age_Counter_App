import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Counter class to manage state, with increment and decrement methods
class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Consumer<Counter>(
              builder: (context, counter, child) {
                return Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<Counter>(
              builder: (context, counter, child) {
                return Text(
                  _getMilestoneMessage(counter.value),
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<Counter>().decrement();
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 20), // Space between the buttons
          FloatingActionButton(
            onPressed: () {
              context.read<Counter>().increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: _getBackgroundColor(context.watch<Counter>().value),
    );
  }

  /// Get the message based on the current counter value (age)
  String _getMilestoneMessage(int value) {
    if (value <= 12) {
      return "You're a child!";
    } else if (value <= 19) {
      return "Teenager time!";
    } else if (value <= 30) {
      return "You're a young adult!";
    } else if (value <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  /// Get the background color based on the current counter value (age)
  Color _getBackgroundColor(int value) {
    if (value <= 12) {
      return Colors.lightBlueAccent;
    } else if (value <= 19) {
      return Colors.lightGreenAccent;
    } else if (value <= 30) {
      return Colors.yellowAccent;
    } else if (value <= 50) {
      return Colors.orangeAccent;
    } else {
      return Colors.grey;
    }
  }
}
