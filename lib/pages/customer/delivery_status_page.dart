import 'package:flutter/material.dart';

class DeliveryStatusPage extends StatelessWidget {
  final List<Map<String, dynamic>> repairRequests;

  const DeliveryStatusPage({super.key, required this.repairRequests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Delivery"),
        backgroundColor: Colors.blue[900],
      ),
      body: repairRequests.isEmpty
          ? const Center(
        child: Text(
          'No repair requests found.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: repairRequests.length,
        itemBuilder: (context, index) {
          final request = repairRequests[index];
          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 4,
            child: ListTile(
              title: Text("Request ID: ${request['id']}"),
              subtitle: Text("Status: ${request['status']}"),
              trailing: ElevatedButton(
                onPressed: () {
                  // Check if delivery is already scheduled
                  if (request['isDeliveryScheduled'] == true) {
                    // Notify user that delivery is already scheduled
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Delivery has already been scheduled for this request.',
                        ),
                      ),
                    );
                  } else if (request['status'] == 'Repair Complete') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Schedule Delivery",
                          ),
                          content: const Text(
                              "Are you sure you want to schedule a delivery for this request?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel",style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Confirm",style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(
                                  context,
                                  '/customer_delivery_page',
                                  arguments: request['id'],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Notify user that delivery can only be scheduled after repair completion
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Delivery can only be scheduled after the repair is complete.',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text(
                  "Schedule Delivery",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
