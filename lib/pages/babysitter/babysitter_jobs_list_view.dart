// lib/pages/babysitter/babysitter_jobs_list_view.dart
import 'package:flutter/material.dart';

class BabysitterJobsListView extends StatelessWidget {
  final List<Map<String, String>> jobs;
  const BabysitterJobsListView({Key? key, required this.jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(child: Text("No available jobs yet."));
    }
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (ctx, i) {
        final job = jobs[i];
        final title = job["title"] ?? "Untitled";
        final desc = job["description"] ?? "";
        final rate = job["rate"] ?? "";
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            subtitle: Text("$desc • $rate"),
            trailing: ElevatedButton(
              onPressed: () {
                // e.g. "Apply" logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Applied to $title")),
                );
              },
              child: const Text("Apply"),
            ),
          ),
        );
      },
    );
  }
}
