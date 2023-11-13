import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('App title')),
        body: const Icon(
          Icons.favorite,
          size: 100,
          color: Colors.red,
        ),
        drawer: const AndroidView(
          key: Key('negro'),
          viewType: String.fromEnvironment('dio'),
        ),
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: 'Settings', icon: Icon(Icons.settings)),
        ]),
      ),
    );
  }
}
