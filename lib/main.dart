import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
