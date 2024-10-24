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
            serviceType: 'Repair',
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
        body: Center(
      // Center the content horizontally
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        // Set maximum width
        padding: const EdgeInsets.all(16.0),
        // Add some padding around the container
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
          title: const Text('Booking Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service Type: ${booking.serviceType}'),
              Text('Date: ${booking.date}'),
              Text('Status: ${booking.status}'),
              Text('ID: ${booking.id}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmCancelBooking(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cancel Booking',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to cancel this service?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  bookings.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
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

  const BookingCard({
    super.key,
    required this.booking,
    this.onViewDetails,
    this.onReschedule,
    this.onCancel,
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
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Request Date: ${booking.date}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                )),
            const SizedBox(height: 8.0),
            Text('Status: ${booking.status}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                )),
            const SizedBox(height: 8.0),
            Text('Request ID: ${booking.id}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                )),
            const SizedBox(height: 8.0),
            Text('Fee: ${booking.fee}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                )),
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
  final String serviceType;
  final String date;
  final String status;
  final String id;
  final String fee;

  Booking({
    required this.serviceType,
    required this.date,
    required this.status,
    required this.id,
    required this.fee,
  });
}
