// lib/pages/parent_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import 'booking_creation_page.dart';
import '../login_page.dart';
import 'rating_page.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final bookingProv = Provider.of<BookingProvider>(context, listen: false);
    if (auth.user != null) {
      await bookingProv.loadBookings(auth.user!.uid, 'parent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final bookingProv = Provider.of<BookingProvider>(context);
    final bookings = bookingProv.myBookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
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
              title: Text('Babysitter: ${booking.babysitterId}'),
              subtitle: Text(
                'From: ${booking.startTime} to ${booking.endTime}\nStatus: ${booking.status}',
              ),
              trailing: booking.status == 'confirmed'
                  ? IconButton(
                      icon: const Icon(Icons.rate_review),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RatingPage(booking: booking),
                          ),
                        );
                      },
                    )
                  : null,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BookingCreationPage()),
          );
        },
      ),
    );
  }
}
