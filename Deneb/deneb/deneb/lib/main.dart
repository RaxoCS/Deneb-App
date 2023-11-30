import 'package:flutter/material.dart';
import 'screens/system_list_screen.dart'; // Asegúrate de tener la importación correcta
import 'class/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deneb App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SystemListScreen(),
    );
  }
}
