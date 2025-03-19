// lib/widgets/job_card.dart
import 'package:flutter/material.dart';
import '../models/job_post.dart';

class JobCard extends StatelessWidget {
  final JobPost job;
  final VoidCallback? onTap;
  const JobCard({Key? key, required this.job, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(job.title),
        subtitle: Text("${job.startTime} - ${job.endTime}\n\$${job.offeredRate}/hr"),
      ),
    );
  }
}
