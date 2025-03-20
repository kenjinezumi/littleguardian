// lib/pages/parent/parent_profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';    // MyAuthProvider
import '../../providers/profile_provider.dart';
import '../../models/user_profile.dart';
import '../profile_edit_page.dart';
import '../settings_page.dart';  // The same settings page we created

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

  // Helper widget for label-value alignment
  Widget _buildProfileRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final profileProv = context.read<ProfileProvider>();

    return FutureBuilder<Map<String, dynamic>?>(
      future: profileProv.fetchProfile(auth.email, auth.role),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data ?? <String, dynamic>{};
        final name = data["name"] ?? "";
        final phone = data["phone"] ?? "";
        final address = data["address"] ?? "";
        final bio = data["bio"] ?? "";
        final avatarUrl = data["avatarUrl"] ?? "";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Logged in as: ${auth.email}"),
              Text("Role: ${auth.role}"),
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  avatarUrl.isEmpty ? "https://via.placeholder.com/150" : avatarUrl,
                ),
              ),
              const SizedBox(height: 20),

              _buildProfileRow("Name", name),
              const SizedBox(height: 8),
              _buildProfileRow("Phone", phone),
              const SizedBox(height: 8),
              _buildProfileRow("Address", address),
              const SizedBox(height: 8),
              _buildProfileRow("Bio", bio),
              const SizedBox(height: 20),

              // Edit Profile button
              ElevatedButton(
                onPressed: () {
                  final userProfile = UserProfile(
                    email: auth.email,
                    role: auth.role,
                    name: name,
                    phone: phone,
                    address: address,
                    bio: bio,
                    avatarUrl: avatarUrl,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileEditPage(profile: userProfile)),
                  );
                },
                child: const Text("Edit Profile"),
              ),
              const SizedBox(height: 20),

              // Logout
              ElevatedButton(
                onPressed: () async {
                  await context.read<MyAuthProvider>().fakeLogout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text("Logout"),
              ),
              const SizedBox(height: 20),

              // NEW: Settings Button
              ElevatedButton.icon(
                icon: const Icon(Icons.settings),
                label: const Text("Settings"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
