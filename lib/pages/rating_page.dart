// lib/pages/rating_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/rating_provider.dart';
import '../../models/booking.dart';
import '../../models/rating.dart';

class RatingPage extends StatefulWidget {
  final Booking booking;
  const RatingPage({Key? key, required this.booking}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _stars = 0;
  final _reviewCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Leave a Rating')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('How was your experience?'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: starIndex <= _stars ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => setState(() => _stars = starIndex),
                );
              }),
            ),
            TextField(
              controller: _reviewCtrl,
              decoration: const InputDecoration(labelText: 'Review'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitRating(context),
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRating(BuildContext context) async {
    if (_stars == 0) {
      _showMessage('Please choose a star rating.');
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user == null) {
      _showMessage('You are not logged in.');
      return;
    }

    final user = auth.user!;
    final booking = widget.booking;
    final ratingId = DateTime.now().millisecondsSinceEpoch.toString(); // or doc().id

    final rating = RatingModel(
      ratingId: ratingId,
      bookingId: booking.bookingId,
      reviewerId: user.uid,
      revieweeId:
          user.role == 'parent' ? booking.babysitterId : booking.parentId,
      stars: _stars,
      reviewText: _reviewCtrl.text.trim(),
    );

    final ratingProv = Provider.of<RatingProvider>(context, listen: false);
    await ratingProv.createRating(rating);

    Navigator.pop(context); // Close the rating page
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
