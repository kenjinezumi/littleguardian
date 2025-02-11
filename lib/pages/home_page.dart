// home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';  // if you need direct user info

import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import 'parent_dashboard_page.dart';
import 'babysitter_dashboard_page.dart';
import 'bookings_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late bool _isParent;

  // We'll define two separate sets of bottom-nav items:
  // One for Parents, one for Babysitters. Alternatively, you can unify them if you prefer.
  late List<BottomNavigationBarItem> _parentNavItems;
  late List<BottomNavigationBarItem> _babysitterNavItems;

  // Similarly, two sets of pages:
  late List<Widget> _parentPages;
  late List<Widget> _babysitterPages;

  @override
  void initState() {
    super.initState();
    // We'll fetch the role from AuthProvider or directly from FirebaseAuth
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isParent = authProvider.user?.role == 'parent';

    // Prepare bottom nav items (Icons, labels):
    _parentNavItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Bookings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    _babysitterNavItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_customize),
        label: 'My Jobs',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month),
        label: 'Bookings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Prepare pages:
    _parentPages = [
      const ParentDashboardPage(),
      const BookingsPage(),
      const ProfilePage(),
    ];

    _babysitterPages = [
      const BabysitterDashboardPage(),
      const BookingsPage(),
      const ProfilePage(),
    ];

    // (Optional) You can load initial booking data here if you want:
    final bookingProv = Provider.of<BookingProvider>(context, listen: false);
    final userId = authProvider.user?.uid;
    if (userId != null) {
      bookingProv.loadBookings(userId, _isParent ? 'parent' : 'babysitter');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPages = _isParent ? _parentPages : _babysitterPages;
    final currentNavItems = _isParent ? _parentNavItems : _babysitterNavItems;

    return Scaffold(
      body: currentPages[_selectedIndex],
      bottomNavigationBar: NavigationBar(  // Material3's NavigationBar
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        destinations: currentNavItems
            .map((item) => NavigationDestination(
                  icon: item.icon,
                  label: item.label ?? '',
                ))
            .toList(),
      ),
    );
  }
}
