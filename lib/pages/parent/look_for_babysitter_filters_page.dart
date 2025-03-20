// lib/pages/parent/look_for_babysitter_filters_page.dart
import 'package:flutter/material.dart';
import '../../models/babysitter_filter.dart';

class LookForBabysitterPreferencesPage extends StatefulWidget {
  final BabysitterFilterModel currentFilters;
  const LookForBabysitterPreferencesPage({
    Key? key,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<LookForBabysitterPreferencesPage> createState() => _LookForBabysitterPreferencesPageState();
}

class _LookForBabysitterPreferencesPageState extends State<LookForBabysitterPreferencesPage> {
  late BabysitterFilterModel _filters;

  @override
  void initState() {
    super.initState();
    // Make a copy so we don't overwrite original until user clicks 'Apply'
    _filters = BabysitterFilterModel(
      minExperience: widget.currentFilters.minExperience,
      maxRate: widget.currentFilters.maxRate,
      cprCertified: widget.currentFilters.cprCertified,
      firstAidCertified: widget.currentFilters.firstAidCertified,
      childEduCertified: widget.currentFilters.childEduCertified,
      maxDistance: widget.currentFilters.maxDistance,
      morningAvailability: widget.currentFilters.morningAvailability,
      afternoonAvailability: widget.currentFilters.afternoonAvailability,
      eveningAvailability: widget.currentFilters.eveningAvailability,
      nightAvailability: widget.currentFilters.nightAvailability,
    );
  }

  void _applyFilters() {
    // Return _filters to the caller (LookForBabysitterPage) via pop
    Navigator.pop(context, _filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Babysitter Preferences"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _applyFilters,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Experience
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Minimum Experience (years)"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _filters.minExperience = int.tryParse(val) ?? 0,
                    decoration: InputDecoration(
                      hintText: "${_filters.minExperience}",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Max Rate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Max Hourly Rate"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _filters.maxRate = double.tryParse(val) ?? 999,
                    decoration: InputDecoration(
                      hintText: "${_filters.maxRate}",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Certifications
            const Text("Certifications (select all that apply):", style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text("CPR Certified"),
              value: _filters.cprCertified,
              onChanged: (val) => setState(() => _filters.cprCertified = val ?? false),
            ),
            CheckboxListTile(
              title: const Text("First Aid Certified"),
              value: _filters.firstAidCertified,
              onChanged: (val) => setState(() => _filters.firstAidCertified = val ?? false),
            ),
            CheckboxListTile(
              title: const Text("Child Education Certified"),
              value: _filters.childEduCertified,
              onChanged: (val) => setState(() => _filters.childEduCertified = val ?? false),
            ),
            const SizedBox(height: 16),

            // Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Max Distance (mi)"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _filters.maxDistance = double.tryParse(val) ?? 1000,
                    decoration: InputDecoration(
                      hintText: "${_filters.maxDistance}",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Availability
            const Text("Availability:", style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text("Morning"),
              value: _filters.morningAvailability,
              onChanged: (val) => setState(() => _filters.morningAvailability = val),
            ),
            SwitchListTile(
              title: const Text("Afternoon"),
              value: _filters.afternoonAvailability,
              onChanged: (val) => setState(() => _filters.afternoonAvailability = val),
            ),
            SwitchListTile(
              title: const Text("Evening"),
              value: _filters.eveningAvailability,
              onChanged: (val) => setState(() => _filters.eveningAvailability = val),
            ),
            SwitchListTile(
              title: const Text("Night"),
              value: _filters.nightAvailability,
              onChanged: (val) => setState(() => _filters.nightAvailability = val),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _applyFilters,
              child: const Text("Apply Filters"),
            )
          ],
        ),
      ),
    );
  }
}
