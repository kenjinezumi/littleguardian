// lib/pages/babysitter/babysitter_job_filter_page.dart
import 'package:flutter/material.dart';
import '../../models/babysitter_job_filter.dart';

class BabysitterJobFilterPage extends StatefulWidget {
  final BabysitterJobFilterModel currentFilters;
  const BabysitterJobFilterPage({
    Key? key,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<BabysitterJobFilterPage> createState() => _BabysitterJobFilterPageState();
}

class _BabysitterJobFilterPageState extends State<BabysitterJobFilterPage> {
  late BabysitterJobFilterModel _filters;

  @override
  void initState() {
    super.initState();
    _filters = BabysitterJobFilterModel(
      minRate: widget.currentFilters.minRate,
      maxRate: widget.currentFilters.maxRate,
      maxDistance: widget.currentFilters.maxDistance,
      morningShift: widget.currentFilters.morningShift,
      afternoonShift: widget.currentFilters.afternoonShift,
      eveningShift: widget.currentFilters.eveningShift,
      nightShift: widget.currentFilters.nightShift,
      comfortableWithPets: widget.currentFilters.comfortableWithPets,
      comfortableWithSpecialNeeds: widget.currentFilters.comfortableWithSpecialNeeds,
      weekdays: widget.currentFilters.weekdays,
      weekends: widget.currentFilters.weekends,
    );
  }

  void _applyFilters() {
    Navigator.pop(context, _filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Filters"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _applyFilters,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Rate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Min Rate (\$)"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _filters.minRate = double.tryParse(val) ?? 0,
                    decoration: InputDecoration(hintText: "${_filters.minRate}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Max Rate (\$)"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _filters.maxRate = double.tryParse(val) ?? 999,
                    decoration: InputDecoration(hintText: "${_filters.maxRate}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Max Distance (miles)"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _filters.maxDistance = double.tryParse(val) ?? 9999,
                    decoration: InputDecoration(hintText: "${_filters.maxDistance}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Shifts
            const Text("Preferred Shift(s):", style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text("Morning"),
              value: _filters.morningShift,
              onChanged: (val) => setState(() => _filters.morningShift = val),
            ),
            SwitchListTile(
              title: const Text("Afternoon"),
              value: _filters.afternoonShift,
              onChanged: (val) => setState(() => _filters.afternoonShift = val),
            ),
            SwitchListTile(
              title: const Text("Evening"),
              value: _filters.eveningShift,
              onChanged: (val) => setState(() => _filters.eveningShift = val),
            ),
            SwitchListTile(
              title: const Text("Night"),
              value: _filters.nightShift,
              onChanged: (val) => setState(() => _filters.nightShift = val),
            ),
            const SizedBox(height: 20),

            // Comfort
            const Text("Comfort:", style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text("Comfortable with Pets"),
              value: _filters.comfortableWithPets,
              onChanged: (val) => setState(() => _filters.comfortableWithPets = val ?? true),
            ),
            CheckboxListTile(
              title: const Text("Comfortable with Special Needs"),
              value: _filters.comfortableWithSpecialNeeds,
              onChanged: (val) => setState(() => _filters.comfortableWithSpecialNeeds = val ?? true),
            ),
            const SizedBox(height: 20),

            // Weekdays/weekends
            const Text("Days of the Week:", style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text("Weekdays"),
              value: _filters.weekdays,
              onChanged: (val) => setState(() => _filters.weekdays = val),
            ),
            SwitchListTile(
              title: const Text("Weekends"),
              value: _filters.weekends,
              onChanged: (val) => setState(() => _filters.weekends = val),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _applyFilters,
              child: const Text("Apply Filters"),
            ),
          ],
        ),
      ),
    );
  }
}
