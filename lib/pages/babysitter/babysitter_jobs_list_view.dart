// lib/pages/babysitter/babysitter_jobs_list_view.dart
import 'package:flutter/material.dart';

class BabysitterJobsListView extends StatelessWidget {
  final List<Map<String, String>> jobs;
  const BabysitterJobsListView({Key? key, required this.jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/illustrations/no_jobs.png', height: 150),
              const SizedBox(height: 16),
              Text(
                "No available jobs yet.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Try adjusting your filters or check back later.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: jobs.length,
      itemBuilder: (ctx, i) {
        final job = jobs[i];
        final title = job["title"] ?? "Untitled";
        final desc = job["description"] ?? "";
        final rate = job["rate"] ?? "";

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("$desc • $rate", style: Theme.of(context).textTheme.bodyMedium),
            trailing: ElevatedButton(
              onPressed: () {
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
