// lib/pages/job_creation_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';

class JobCreationPage extends StatefulWidget {
  const JobCreationPage({Key? key}) : super(key: key);

  @override
  State<JobCreationPage> createState() => _JobCreationPageState();
}

class _JobCreationPageState extends State<JobCreationPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  void _createJob() {
    final auth = context.read<MyAuthProvider>();
    final jobProv = context.read<JobProvider>();

    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final rate = _rateCtrl.text.trim().isEmpty ? '0' : _rateCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Title required!")));
      return;
    }

    // Construct a simple map for the new job
    final newJob = {
      "title": title,
      "description": desc,
      "rate": "\$$rate/hr",
    };

    // We'll use the parent's email as an ID
    jobProv.createJob(auth.email, newJob);

    // Pop back to the My Jobs tab
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Create Job")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          margin: const EdgeInsets.all(8),
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: "Job Title"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _rateCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Hourly Rate (USD)"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createJob,
                  child: const Text("Create"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
