import 'package:flutter/material.dart';
import 'customer_pickup_page.dart';
import 'customer_repair_page.dart';

class CustomerContentPage extends StatefulWidget {
  const CustomerContentPage({super.key});

  @override
  State<CustomerContentPage> createState() => _CustomerContentPageState();
}

class _CustomerContentPageState extends State<CustomerContentPage> {
  final PageController _controller = PageController(viewportFraction: 0.85); // Slightly reduce the card size

  @override
  Widget build(BuildContext context) {
    Widget buildCard(String title, String description, Widget nextPage) =>
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.85, // Responsive width
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[900]!, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 42, // Reduce the font size for better fitting
                                fontWeight: FontWeight.bold,
                                fontFamily: "nunito",
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontFamily: "Mont",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32, // Add spacing between the description and button
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity, // Ensure the button spans the card width
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => nextPage),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "OPEN SERVICE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "nunito",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );

    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          buildCard(
            "REPAIR",
            'Book your luggage to get repaired by our experts',
            const CustomerRepairPage(),
          ),
          buildCard(
            "PICKUP",
            'Schedule a pickup for your luggage after booking',
            const CustomerPickupPage(),
          ),
          buildCard(
            "DELIVERY",
            'Get your repaired luggage delivered back to you',
            const CustomerRepairPage(),
          ),
        ],
      ),
    );
  }
}
