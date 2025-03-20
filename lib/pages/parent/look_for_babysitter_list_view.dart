// lib/pages/parent/look_for_babysitter_list_view.dart
import 'package:flutter/material.dart';

class LookForBabysitterListView extends StatelessWidget {
  final List<Map<String, String>> babysitters;
  const LookForBabysitterListView({Key? key, required this.babysitters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (babysitters.isEmpty) {
      return const Center(child: Text("No babysitters found."));
    }
    return ListView.builder(
      itemCount: babysitters.length,
      itemBuilder: (ctx, i) {
        final sitter = babysitters[i];
        final name = sitter["name"] ?? "Unknown";
        final desc = sitter["desc"] ?? "";
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(name),
            subtitle: Text(desc),
            trailing: ElevatedButton(
              onPressed: () {
                // For example, "Request" or "Contact" logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Requested $name")),
                );
              },
              child: const Text("Request"),
            ),
          ),
        );
      },
    );
  }
}
