import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CustomerBookingPage extends StatefulWidget {
  const CustomerBookingPage({super.key});

  @override
  _CustomerBookingPageState createState() => _CustomerBookingPageState();
}

class _CustomerBookingPageState extends State<CustomerBookingPage> {
  List<Booking> bookings = [];
  String filter = 'All';
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserBookings();
  }

  Future<void> _fetchUserBookings() async {
    if (currentUser != null) {
      try {
        // Fetch repair requests from Firestore where userId matches the current user
        QuerySnapshot querySnapshot = await _firestore
            .collection('repair_request')
            .where('userId', isEqualTo: currentUser!.uid)
            .get();

        List<Booking> userBookings = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          Timestamp timestamp = data['date'] as Timestamp;
          DateTime dateTime = timestamp.toDate();
          String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

          return Booking(
            name: data['customerName'] ?? 'Unknown',
            surname: data['customerSurname'] ?? 'Unknown',
            email: data['customerEmail'] ?? 'Unknown',
            serviceType: 'Repair',
            brand: data['brand'] ?? 'Unknown',
            description: data['description'] ?? 'Unknown',
            date: formattedDate,
            status: data['status'] ?? 'Unknown',
            id: doc.id,
            fee: data['fee'] ?? 'Unknown',
          );
        }).toList();

        setState(() {
          bookings = userBookings;
        });
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching bookings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Booking> filteredBookings = bookings.where((booking) {
      if (filter == 'All') return true;
      if (filter == 'Active') return booking.status != 'Completed';
      if (filter == 'Completed') return booking.status == 'Completed';
      return false;
    }).toList();

    return Scaffold(
        key: _scaffoldMessengerKey,
        body: Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildFilterButton('All', filter),
                  const SizedBox(width: 12),
                  _buildFilterButton('Active', filter),
                  const SizedBox(width: 12),
                  _buildFilterButton('Completed', filter),
                ],
              ),
            ),
            Expanded(
              child: filteredBookings.isEmpty
                  ? const Center(child: Text('No bookings available'))
                  : ListView.builder(
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        return BookingCard(
                          booking: filteredBookings[index],
                          onViewDetails: () {
                            _showBookingDetails(
                                context, filteredBookings[index]);
                          },
                          onReschedule:
                              filteredBookings[index].status == 'Completed'
                                  ? null
                                  : () {
                                      // Handle reschedule action
                                      print(
                                          'Reschedule booking ${filteredBookings[index].id}');
                                    },
                          onCancel:
                              filteredBookings[index].status == 'Completed'
                                  ? null
                                  : () {
                                      _confirmCancelBooking(index);
                                    },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ));
  }

  GestureDetector _buildFilterButton(String filterName, String currentFilter) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filter = filterName;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          color: filter == filterName ? Colors.blue[900] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          filterName,
          style: TextStyle(
            color: filter == filterName ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Mont",
          ),
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Booking Details',
            style: TextStyle(fontFamily: "Mont", color: Theme.of(context).colorScheme.primary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service Type: ${booking.serviceType}',
                  style: const TextStyle(fontFamily: "Mont")),
              Text('Request Date: ${booking.date}',
                  style: const TextStyle(fontFamily: "Mont")),
              Text('Status: ${booking.status}',
                  style: const TextStyle(fontFamily: "Mont")),
              Text('ID: ${booking.id}',
                  style: const TextStyle(fontFamily: "Mont")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontFamily: "Mont"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmCancelBooking(int index) {
    // Check if the booking status is already 'Cancelled'
    if (bookings[index].status == 'Cancelled') {
      showDialog(context: context, builder: (BuildContext context){
        return const AlertDialog(
          content: Text('This booking has already been cancelled.', style: TextStyle(fontFamily: "Mont"),),
        );
      });
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Cancel Booking',
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontFamily: "Mont"),
          ),
          content: const Text(
            'Are you sure you want to cancel this service?',
            style: TextStyle(color: Colors.white, fontFamily: "Mont"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontFamily: "Mont"),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  // Update the booking's status to 'Cancelled' in Firestore
                  String bookingId = bookings[index].id;
                  await _firestore.collection('repair_request').doc(bookingId).update({
                    'status': 'Cancelled',
                  });

                  // Update the status in the local bookings list
                  setState(() {
                    bookings[index].status = 'Cancelled';
                  });

                  // Notify the user of success
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking cancelled successfully.')),
                  );
                } catch (e) {
                  // Handle any errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error cancelling booking: $e')),
                  );
                }
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontFamily: "Mont"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onViewDetails;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onPayment;

  const BookingCard({
    super.key,
    required this.booking,
    this.onViewDetails,
    this.onReschedule,
    this.onCancel,
    this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[800]!, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Type: ${booking.serviceType}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                  fontFamily: "Mont"),
            ),
            const SizedBox(height: 8.0),
            Text('Request Date: ${booking.date}',
                style: const TextStyle(
                    fontSize: 16.0, color: Colors.white, fontFamily: "Mont")),
            const SizedBox(height: 8.0),
            Text('Status: ${booking.status}',
                style: const TextStyle(
                    fontSize: 16.0, color: Colors.white, fontFamily: "Mont")),
            const SizedBox(height: 8.0),
            Text('Request ID: ${booking.id}',
                style: const TextStyle(
                    fontSize: 16.0, color: Colors.white, fontFamily: "Mont")),
            const SizedBox(height: 8.0),
            Text('Fee: ${booking.fee}',
                style: const TextStyle(
                    fontSize: 16.0, color: Colors.white, fontFamily: "Mont")),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 95,
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2),
                if (onReschedule != null)
                  SizedBox(
                    width: 128,
                    child: ElevatedButton(
                      onPressed: onReschedule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Reschedule',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 2),
                if (onCancel != null)
                  SizedBox(
                    width: 95,
                    child: ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Booking {
  final String name;
  final String surname;
  final String email;
  final String serviceType;
  final String brand;
  final String description;
  final String date;
  String status;
  final String id;
  final String fee;

  Booking({
    required this.name,
    required this.surname,
    required this.email,
    required this.serviceType,
    required this.brand,
    required this.description,
    required this.date,
    required this.status,
    required this.id,
    required this.fee,
  });
}
