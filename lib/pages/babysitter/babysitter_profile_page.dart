// lib/pages/babysitter/babysitter_profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/user_profile.dart';
import '../profile_edit_page.dart';

class BabysitterProfilePage extends StatelessWidget {
  const BabysitterProfilePage({Key? key}) : super(key: key);

  // This helper widget aligns a label and value in a row.
  Widget _buildProfileRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Value - wrapped in Expanded or Flexible if you want multi-line
        Expanded(
          child: Text(value),
        ),
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
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        if (isLoading) {
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

              // Show an avatar, if you want:
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(avatarUrl.isEmpty
                    ? "https://via.placeholder.com/150"
                    : avatarUrl),
              ),
              const SizedBox(height: 20),

              // Our aligned label-value rows:
              _buildProfileRow("Name", name),
              const SizedBox(height: 8),
              _buildProfileRow("Phone", phone),
              const SizedBox(height: 8),
              _buildProfileRow("Address", address),
              const SizedBox(height: 8),
              _buildProfileRow("Bio", bio),
              const SizedBox(height: 20),

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
                    MaterialPageRoute(
                      builder: (_) => ProfileEditPage(profile: userProfile),
                    ),
                  );
                },
                child: const Text("Edit Profile"),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await context.read<MyAuthProvider>().fakeLogout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        );
      },
    );
  }
}
