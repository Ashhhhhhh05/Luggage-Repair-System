import 'package:flutter/material.dart';

class CustomerBookingPage extends StatefulWidget {
  const CustomerBookingPage({super.key});


  @override
  _CustomerBookingPageState createState() => _CustomerBookingPageState();
}

class _CustomerBookingPageState extends State<CustomerBookingPage> {
  List<Booking> bookings = [
    Booking(
      serviceType: 'Repair',
      date: '2024-08-01',
      status: 'Scheduled',
      id: '0001',
    ),
  ];

  String filter = 'All';

  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(' ')[0];
      });
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

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filter = 'All';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      decoration: BoxDecoration(
                        color: filter == 'All' ? Colors.blue[900] : Colors.grey[300],
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
                        'All',
                        style: TextStyle(
                          color: filter == 'All' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Space between buttons
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filter = 'Active';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      decoration: BoxDecoration(
                        color: filter == 'Active' ? Colors.blue[900] : Colors.grey[300],
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
                        'Active',
                        style: TextStyle(
                          color: filter == 'Active' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Space between buttons
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filter = 'Completed';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                      decoration: BoxDecoration(
                        color: filter == 'Completed' ? Colors.blue[900] : Colors.grey[300],
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
                        'Completed',
                        style: TextStyle(
                          color: filter == 'Completed' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  return BookingCard(
                    booking: filteredBookings[index],
                    onViewDetails: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Booking Details'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Service Type: ${filteredBookings[index].serviceType}'),
                                Text('Date: ${filteredBookings[index].date}'),
                                Text('Status: ${filteredBookings[index].status}'),
                                Text('ID: ${filteredBookings[index].id}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onReschedule: filteredBookings[index].status == 'Completed' ? null : () {
                      // Handle reschedule action
                      print('Reschedule booking ${filteredBookings[index].id}');
                    },
                    onCancel: filteredBookings[index].status == 'Completed' ? null : () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Cancel Booking'),
                            content: const Text('Are You Sure You Want To Cancel Service?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    bookings.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onViewDetails;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const BookingCard({super.key,
    required this.booking,
    this.onViewDetails,
    this.onReschedule,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
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
            Text('Date: ${booking.date}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),),
            const SizedBox(height: 8.0),
            Text('Status: ${booking.status}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),),
            const SizedBox(height: 8.0),
            Text('ID: ${booking.id}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900], // Custom button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('View Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
                if (onReschedule != null)
                  ElevatedButton(
                    onPressed: onReschedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900], // Custom button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Reschedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                if (onCancel != null)
                  ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900], // Custom button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
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

  Booking({
    required this.serviceType,
    required this.date,
    required this.status,
    required this.id,
  });
}





