// lib/widgets/babysitter_card.dart
import 'package:flutter/material.dart';
import '../models/babysitter_profile.dart';

class BabysitterCard extends StatelessWidget {
  final BabysitterProfile babysitter;
  final VoidCallback? onTap;
  const BabysitterCard({Key? key, required this.babysitter, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(babysitter.fullName),
        subtitle: Text("Rate: \$${babysitter.hourlyRate}/hr, Rating: ${babysitter.rating}"),
      ),
    );
  }
}
