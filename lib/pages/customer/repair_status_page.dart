import 'package:flutter/material.dart';

class RepairStatusPage extends StatelessWidget {
  final List<Map<String, dynamic>> repairRequests;

  const RepairStatusPage({super.key, required this.repairRequests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup Requests"),
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
                        // Handle the pickup scheduling logic here
                        if (request['status'] == 'Approved') {
                          // Example: Navigate to a pickup confirmation page
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "Schedule Pickup",
                                ),
                                content: const Text(
                                    "Are you sure you want to schedule a pickup for this request?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Confirm",style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushNamed(
                                          context, '/customer_pickup_page',
                                        arguments: request['id'],
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // If not approved, show a message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Pickup can only be scheduled for approved requests.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                      ),
                      child: const Text("Schedule Pickup", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
