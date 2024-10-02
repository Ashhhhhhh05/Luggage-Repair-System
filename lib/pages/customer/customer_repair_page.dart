import 'package:flutter/material.dart';

class CustomerRepairPage extends StatefulWidget {
  const CustomerRepairPage({super.key});

  @override
  State<CustomerRepairPage> createState() => CustomerRepairPageState();
}

class CustomerRepairPageState extends State<CustomerRepairPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          // Back button container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              label: const Text(
                "Back",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Mont",
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(50, 40),
                backgroundColor: Colors.blue[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            // Adjust padding to create space below the back button
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Submit Repair request",
                  style: TextStyle(
                    color: Colors.blue[900]!,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: "june",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 140, vertical: 70),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 3),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 50,
                        color: Colors.blue[900],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Add photos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Additional content for the photo container
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Type of luggage",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Mont",
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      )),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 3,
                      )),
                    ),
                    dropdownColor: Colors.blueAccent,
                    items: const [
                      DropdownMenuItem(
                          value: '1',
                          child: Text(
                            'Suitcase',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Mont",
                            ),
                          )),
                      DropdownMenuItem(
                          value: '2',
                          child: Text(
                            'Backpack',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mont"),
                          )),
                      DropdownMenuItem(
                          value: '3',
                          child: Text(
                            'Garment Bag',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mont"),
                          )),
                      DropdownMenuItem(
                          value: '4',
                          child: Text(
                            'Carry-On Bag',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mont"),
                          )),
                      DropdownMenuItem(
                          value: '5',
                          child: Text(
                            'Rolling luggage',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mont"),
                          )),
                      DropdownMenuItem(
                          value: '6',
                          child: Text(
                            'Briefcase',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mont"),
                          )),
                      DropdownMenuItem(
                          value: '7',
                          child: Text(
                            'Travel Organizer',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mont"),
                          )),
                      DropdownMenuItem(
                          value: '8',
                          child: Text(
                            'Hard Shell luggage',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mont"),
                          )),
                    ],
                    onChanged: (value) {}),
                const SizedBox(
                  height: 16,
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: "Brand",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mont",
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 3)),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mont",
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 3,
                    )),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Note: After submitting a repair request, you will receive an estimated cost."
                  " Once you have the estimate, you can schedule a pickup for your luggage."
                  " You can view the estimated repair cost on your Bookings page.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: "Mont",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 60),
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "nunito",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
