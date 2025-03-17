// lib/dashboard_page.dart
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(
        child: Text(
          'Here is your refined Dashboard!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
