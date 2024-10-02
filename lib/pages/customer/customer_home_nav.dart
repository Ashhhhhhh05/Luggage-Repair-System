import 'package:final_app/components/my_drawer_tile.dart';
import 'package:final_app/pages/customer/customer_settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'customer_account_page.dart';
import 'customer_booking_page.dart';
import 'customer_content_page.dart';
import 'customer_messages_page.dart';

class CustomerHomeNav extends StatefulWidget {
  const CustomerHomeNav({super.key});

  @override
  State<CustomerHomeNav> createState() => _CustomerHomeNavState();
}

class _CustomerHomeNavState extends State<CustomerHomeNav> {
  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  int selectedIndex = 0;

  final List<Widget> pages = [
    const CustomerContentPage(),
    const CustomerBookingPage(),
    CustomerMessagesPage(),
    const CustomerAccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // App Logo
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Text(
                "Matrix",
                style: TextStyle(
                  color: Colors.blue[900]!,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  fontFamily: "june",
                ),
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Divider(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),

            // Push to Home Page
            MyDrawerTile(
              text: "H O M E",
              icon: Icons.home,
              onTap: () => Navigator.pushNamed(context, '/customer_home_nav'),
            ),

            // Push to Settings Page
            MyDrawerTile(
              text: "S E T T I N G S",
              icon: Icons.settings_outlined,
              onTap: () =>
                  Navigator.pushNamed(context, '/customer_settings_page'),
            ),

            const Spacer(),

            // Log out
            MyDrawerTile(
                text: "L O G O U T", icon: Icons.logout, onTap: signUserOut),

            const SizedBox(height: 25),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.tertiary,
          size: 30,
        ),
        title: Text(
          "Matrix",
          style: TextStyle(
            color: Colors.blue[900]!,
            fontWeight: FontWeight.bold,
            fontSize: 50,
            fontFamily: "june",
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).colorScheme.tertiary,
                size: 30,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const CustomerSettingsPage(),
                    ),
                  ),
                );
              }),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              //color: Colors.black26.withOpacity(0.4),
              color: Colors.blueAccent,
            )
          ],
        ),
        child: GNav(
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.calendar_today, text: "Bookings"),
            GButton(icon: Icons.messenger, text: "Messages"),
            GButton(icon: Icons.account_circle, text: "Account"),
          ],
          activeColor: Colors.white,
          color: Colors.white,
          tabBackgroundColor: Colors.blue[900]!,
          padding: const EdgeInsets.all(12),
          curve: Curves.bounceIn,
          iconSize: 28,
          gap: 5,
          duration: const Duration(milliseconds: 500),
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}
