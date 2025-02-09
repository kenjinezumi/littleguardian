// lib/pages/booking_creation_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class BookingCreationPage extends StatefulWidget {
  const BookingCreationPage({Key? key}) : super(key: key);

  @override
  State<BookingCreationPage> createState() => _BookingCreationPageState();
}

class _BookingCreationPageState extends State<BookingCreationPage> {
  final _babysitterIdCtrl = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _babysitterIdCtrl,
              decoration: const InputDecoration(labelText: 'Babysitter UID'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDateTime(isStart: true),
                    child: Text(_startTime == null
                        ? 'Start Time'
                        : _startTime.toString()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDateTime(isStart: false),
                    child: Text(_endTime == null
                        ? 'End Time'
                        : _endTime.toString()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createBooking,
              child: const Text('Create Booking'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime({required bool isStart}) async {
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

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        _startTime = dateTime;
      } else {
        _endTime = dateTime;
      }
    });
  }

  Future<void> _createBooking() async {
    if (_startTime == null || _endTime == null) {
      _showMessage('Please select both start and end times.');
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user == null) return;

    final bookingProv = Provider.of<BookingProvider>(context, listen: false);
    await bookingProv.createBooking(
      parentId: auth.user!.uid,
      babysitterId: _babysitterIdCtrl.text.trim(),
      startTime: _startTime!,
      endTime: _endTime!,
    );

    Navigator.pop(context);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
