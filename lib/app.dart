import 'package:flutter/material.dart';

class LittleGuardianApp extends StatelessWidget {
  const LittleGuardianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LittleGuardian',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const Scaffold(
        body: Center(child: Text("Hello from LittleGuardian!")),
      ),
    );
  }
}
