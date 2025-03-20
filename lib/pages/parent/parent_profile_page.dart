// lib/pages/parent/parent_profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/user_profile.dart';
import '../profile_edit_page.dart';

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

  /// Builds a single centered row: "Label: Value"
  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // small vertical gap
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // center row horizontally
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
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

        // If no data, fallback to empty map
        final data = snapshot.data ?? <String, dynamic>{};
        final name = data["name"] ?? "";
        final phone = data["phone"] ?? "";
        final address = data["address"] ?? "";
        final bio = data["bio"] ?? "";
        final avatarUrl = data["avatarUrl"] ?? "";

        return SingleChildScrollView(
          child: Center( // center the entire column
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // No need for crossAxisAlignment here; Center + Row does the job
                children: [
                  Text("Logged in as: ${auth.email}"),
                  Text("Role: ${auth.role}"),
                  const SizedBox(height: 20),

                  // Profile rows
                  _buildProfileRow("Name", name),
                  _buildProfileRow("Phone", phone),
                  _buildProfileRow("Address", address),
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
            ),
          ),
        );
      },
    );
  }
}
