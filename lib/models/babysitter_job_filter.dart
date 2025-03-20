// lib/models/babysitter_job_filter_model.dart
class BabysitterJobFilterModel {
  // Rate range: e.g., min to max wage they'd accept
  double minRate;
  double maxRate;

  // Distance from your location
  double maxDistance; // in miles or km, your choice

  // Start time or shift preferences: morning, afternoon, evening, night
  bool morningShift;
  bool afternoonShift;
  bool eveningShift;
  bool nightShift;

  // Special needs or pets acceptance
  bool comfortableWithPets;
  bool comfortableWithSpecialNeeds;

  // Possibly days of week if you want (Mon-Fri, weekends, etc.)
  bool weekdays;
  bool weekends;

  // Possibly a date range filter if you want
  // etc.

  BabysitterJobFilterModel({
    this.minRate = 0,
    this.maxRate = 999,
    this.maxDistance = 9999,
    this.morningShift = false,
    this.afternoonShift = false,
    this.eveningShift = false,
    this.nightShift = false,
    this.comfortableWithPets = true,
    this.comfortableWithSpecialNeeds = true,
    this.weekdays = true,
    this.weekends = true,
  });

  // Add any fromMap/toMap if storing in a DB or local
}
