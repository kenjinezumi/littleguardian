// lib/pages/parent/job_creation_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';   // or your MyAuthProvider
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
  final _latCtrl = TextEditingController();  // optional location
  final _lngCtrl = TextEditingController();  // optional location

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  void _createJob() {
    final auth = context.read<MyAuthProvider>(); // or AuthProvider
    final parentEmail = auth.email; // or however you store parent's ID

    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title is required.")),
      );
      return;
    }

    final job = <String, String>{
      "title": title,
      "description": _descCtrl.text.trim(),
      "rate": _rateCtrl.text.trim(),
    };

    // If lat/lng are provided, store them
    final lat = _latCtrl.text.trim();
    final lng = _lngCtrl.text.trim();
    if (lat.isNotEmpty && lng.isNotEmpty) {
      job["lat"] = lat;
      job["lng"] = lng;
    }

    // Now create the job in memory
    final jobProv = context.read<JobProvider>();
    jobProv.createJob(parentEmail, job);

    Navigator.pop(context); // go back to MyJobs or wherever
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post a Babysitting Job")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              decoration: const InputDecoration(labelText: "Rate (\$ / hr)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _latCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Latitude (optional)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lngCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Longitude (optional)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createJob,
              child: const Text("Create Job"),
            ),
          ],
        ),
      ),
    );
  }
}
