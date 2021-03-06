import 'package:flutter/material.dart';
import 'package:tictactoe/pages/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.indigo),
      home: new HomePage(),
    );
  }
}
