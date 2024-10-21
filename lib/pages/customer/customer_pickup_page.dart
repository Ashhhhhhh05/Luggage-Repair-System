import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerPickupPage extends StatefulWidget {
  const CustomerPickupPage({super.key});

  @override
  State<CustomerPickupPage> createState() => _CustomerPickupPageState();
}

class _CustomerPickupPageState extends State<CustomerPickupPage> {
  final _formKey = GlobalKey<FormState>();
  final _pickupAddressController = TextEditingController();
  final _specialInstructionController = TextEditingController();
  DateTime? _preferredDate;
  TimeOfDay? _preferredTime;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_preferredDate == null) {
        _showSnackBar('Please select a preferred date.');
      } else if (_preferredTime == null) {
        _showSnackBar('Please select a preferred time.');
      } else {
        print('Pickup Address: ${_pickupAddressController.text}');
        print('Preferred Date: ${_preferredDate}');
        print('Preferred Time: ${_preferredTime}');
        print('Special Instruction: ${_specialInstructionController.text}');
        _showDialog();
      }
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white, // You can adjust the color here
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[600],
              ),
              const SizedBox(width: 10),
              Text(
                'Pickup Scheduled',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: "Mont",
                ),
              ),
            ],
          ),
          content: Text(
            'Your pickup has been scheduled successfully.',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 18,
              fontFamily: "Nunito",
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[900], // Button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito",
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'nunito'),
        ),
        backgroundColor: Colors.red[900]!,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[100]!, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Padding(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Schedule Pickup",
                        style: TextStyle(
                          color: Colors.blue[900]!,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: "june",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: _pickupAddressController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_on),
                              labelText: 'Pickup Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Pickup Address!!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final DateTime? pickedDate =
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                );
                                setState(() {
                                  _preferredDate = pickedDate;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 60),
                                backgroundColor: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      _preferredDate == null
                                          ? 'Preferred Date'
                                          : DateFormat('yyyy-MM-dd')
                                          .format(_preferredDate!),
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: "nunito",
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final TimeOfDay? pickedTime =
                                await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                setState(() {
                                  _preferredTime = pickedTime;
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      _preferredTime == null
                                          ? 'Preferred Time'
                                          : '${_preferredTime!.hour}:${_preferredTime!.minute}',
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: "nunito",
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 60),
                                backgroundColor: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: _specialInstructionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Special Instruction',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Special Instruction!!';
                              }
                              return null;
                            },
                          ),

                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 60),
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
