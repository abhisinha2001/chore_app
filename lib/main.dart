import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(ChoreApp());
}

class ChoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chore App',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
