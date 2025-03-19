// lib/pages/profile_edit_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';

class ProfileEditPage extends StatefulWidget {
  final UserProfile profile;
  const ProfileEditPage({Key? key, required this.profile}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _avatarCtrl;
  late String _role;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameCtrl = TextEditingController(text: p.name);
    _phoneCtrl = TextEditingController(text: p.phone);
    _addressCtrl = TextEditingController(text: p.address);
    _bioCtrl = TextEditingController(text: p.bio);
    _avatarCtrl = TextEditingController(text: p.avatarUrl);
    _role = p.role;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _bioCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Rebuild a final profile object
    final updated = widget.profile.copyWith(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      avatarUrl: _avatarCtrl.text.trim(),
    );

    // Overwrite the role
    final finalProfile = UserProfile(
      email: updated.email,
      role: _role,
      name: updated.name,
      phone: updated.phone,
      address: updated.address,
      bio: updated.bio,
      avatarUrl: updated.avatarUrl,
    );

    // Now we pass userId = finalProfile.email, plus the data map
    final userId = finalProfile.email; 
    final data = {
      'role': finalProfile.role,
      'name': finalProfile.name,
      'phone': finalProfile.phone,
      'address': finalProfile.address,
      'bio': finalProfile.bio,
      'avatarUrl': finalProfile.avatarUrl,
    };

    context.read<ProfileProvider>().updateProfile(
      userId: userId,
      data: data,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_avatarCtrl.text),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _avatarCtrl,
              decoration: const InputDecoration(
                labelText: "Avatar URL",
                prefixIcon: Icon(Icons.image),
              ),
              onChanged: (val) => setState(() {}), // re-draw
            ),
            const SizedBox(height: 24),
            _buildTextField(_nameCtrl, "Name", Icons.person),
            const SizedBox(height: 16),
            _buildRoleDropdown(),
            const SizedBox(height: 16),
            _buildTextField(_phoneCtrl, "Phone", Icons.phone),
            const SizedBox(height: 16),
            _buildTextField(_addressCtrl, "Address", Icons.home),
            const SizedBox(height: 16),
            _buildTextField(_bioCtrl, "Bio", Icons.info, maxLines: 3),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, right: 16),
          child: Icon(Icons.people),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _role,
            items: const [
              DropdownMenuItem(value: 'parent', child: Text("Parent")),
              DropdownMenuItem(value: 'babysitter', child: Text("Babysitter")),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => _role = val);
              }
            },
            decoration: const InputDecoration(labelText: "Role"),
          ),
        ),
      ],
    );
  }
}
