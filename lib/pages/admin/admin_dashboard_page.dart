// lib/pages/admin/admin_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart' show MyAuthProvider;

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _userCount = 0;
  int _unverifiedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    final unverified = await adminProv.fetchUnverifiedUsers();
    final totalUsers = await adminProv.getUserCount();
    setState(() {
      _unverifiedCount = unverified.length;
      _userCount = totalUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<MyAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Total Users: $_userCount"),
            Text("Unverified Users: $_unverifiedCount"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // e.g. navigate to user verification page
              },
              child: const Text("Manage Verifications"),
            ),
            ElevatedButton(
              onPressed: () {
                // e.g. navigate to disputes
              },
              child: const Text("View Disputes"),
            ),
          ],
        ),
      ),
    );
  }
}
