import 'package:flutter/material.dart';

import 'package:check/src/pages/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueGrey,
        fontFamily: 'IBM Plex Mono',
      ),
      home: HomePage(title: 'Check'),
    );
  }
}
