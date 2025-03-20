// lib/pages/babysitter/babysitter_profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/user_profile.dart';
import '../profile_edit_page.dart';

class BabysitterProfilePage extends StatelessWidget {
  const BabysitterProfilePage({Key? key}) : super(key: key);

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

              Text("Name: $name"),
              Text("Phone: $phone"),
              Text("Address: $address"),
              Text("Bio: $bio"),
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
