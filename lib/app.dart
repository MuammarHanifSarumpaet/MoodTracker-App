import 'package:flutter/material.dart';

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Mood Tracker App',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
