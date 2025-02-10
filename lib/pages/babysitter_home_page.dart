// lib/pages/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import './login_page.dart';
import 'rating_page.dart';

class BabysitterHomePage extends StatefulWidget {
  const BabysitterHomePage({Key? key}) : super(key: key);

  @override
  State<BabysitterHomePage> createState() => _BabysitterHomePageState();
}

class _BabysitterHomePageState extends State<BabysitterHomePage> {
  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final bookingProv = Provider.of<BookingProvider>(context, listen: false);
    if (auth.user != null) {
      await bookingProv.loadBookings(auth.user!.uid, 'babysitter');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final bookingProv = Provider.of<BookingProvider>(context);
    final bookings = bookingProv.myBookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Babysitter Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) =>  LoginPage()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadBookings,
        child: ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return ListTile(
              title: Text('Parent: ${booking.parentId}'),
              subtitle: Text(
                'From: ${booking.startTime} to ${booking.endTime}\nStatus: ${booking.status}',
              ),
              trailing: _buildTrailing(context, booking),
            );
          },
        ),
      ),
    );
  }

  Widget? _buildTrailing(BuildContext context, Booking booking) {
    if (booking.status == 'requested') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              Provider.of<BookingProvider>(context, listen: false)
                  .updateBookingStatus(booking.bookingId, 'confirmed');
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              Provider.of<BookingProvider>(context, listen: false)
                  .updateBookingStatus(booking.bookingId, 'canceled');
            },
          ),
        ],
      );
    } else if (booking.status == 'confirmed') {
      return IconButton(
        icon: const Icon(Icons.rate_review),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RatingPage(booking: booking),
            ),
          );
        },
      );
    }
    return null;
  }
}
