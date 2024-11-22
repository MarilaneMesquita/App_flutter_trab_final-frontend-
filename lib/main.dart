import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CrudApp());
}

class CrudApp extends StatelessWidget {
  const CrudApp({Key? key}) : super(key: key); // Construtor declarado como const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), 
    );
  }
}
