// lib/models/babysitter_filter_model.dart (if separate)
class BabysitterFilterModel {
  int minExperience;           // in years
  double maxRate;              // hourly
  bool cprCertified;
  bool firstAidCertified;
  bool childEduCertified;
  double maxDistance;          // in miles or km
  bool morningAvailability;
  bool afternoonAvailability;
  bool eveningAvailability;
  bool nightAvailability;

  // Possibly more fields: gender preference, languages, etc.

  BabysitterFilterModel({
    this.minExperience = 0,
    this.maxRate = 999,
    this.cprCertified = false,
    this.firstAidCertified = false,
    this.childEduCertified = false,
    this.maxDistance = 1000,
    this.morningAvailability = false,
    this.afternoonAvailability = false,
    this.eveningAvailability = false,
    this.nightAvailability = false,
  });

  // You can add fromMap / toMap if storing or retrieving from DB
}
