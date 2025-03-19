// lib/pages/parent/job_creation_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../models/job_post.dart';

class JobCreationPage extends StatefulWidget {
  const JobCreationPage({Key? key}) : super(key: key);

  @override
  State<JobCreationPage> createState() => _JobCreationPageState();
}

class _JobCreationPageState extends State<JobCreationPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  bool _isRecurring = false;
  DateTime? _start;
  DateTime? _end;

  Future<void> _pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;

    final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _start = dt;
      } else {
        _end = dt;
      }
    });
  }

  Future<void> _createJob() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_start == null || _end == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select start/end time")));
      return;
    }

    final job = JobPost(
      jobId: "temp",
      parentId: user.uid,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      isRecurring: _isRecurring,
      startTime: _start!,
      endTime: _end!,
      offeredRate: double.tryParse(_rateCtrl.text.trim()) ?? 0,
    );
    await Provider.of<JobProvider>(context, listen: false).createJobPost(job);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Offered Rate (hourly)"),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _isRecurring,
              onChanged: (val) => setState(() => _isRecurring = val),
              title: const Text("Recurring?"),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDate(true),
                    child: Text(_start == null ? "Start" : _start.toString()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDate(false),
                    child: Text(_end == null ? "End" : _end.toString()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createJob,
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
