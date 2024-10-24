import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerDeliveryPage extends StatefulWidget {
  const CustomerDeliveryPage({super.key});

  @override
  State<CustomerDeliveryPage> createState() => _CustomerDeliveryPageState();
}

class _CustomerDeliveryPageState extends State<CustomerDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final _deliveryAddressController = TextEditingController();
  final _specialInstructionController = TextEditingController();
  DateTime? _preferredDate;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_preferredDate == null) {
        _showSnackBar('Please select a preferred date.');
      } else {
        print('Delivery Address: ${_deliveryAddressController.text}');
        print('Preferred Date: ${_preferredDate}');
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
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[600],
              ),
              SizedBox(width: 10),
              Text(
                'Delivery Scheduled',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: "Mont",
                ),
              )
            ],
          ),
          content: Text(
            'Your delivery has been scheduled successfully,',
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
                backgroundColor: Colors.blue[900],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito",
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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
          style: TextStyle(color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'nunito'),
        ),
        backgroundColor: Colors.red[900]!,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: Duration(seconds: 3),
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
                padding: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  label: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mont",
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 40),
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(
                  vertical: 100, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Schedule Delivery",
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
                            controller: _deliveryAddressController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_on),
                              labelText: 'Delivery Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Delivery Address!!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025),
                              );
                              setState(() {
                                _preferredDate = pickedDate;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Center(
                                    child: Text(
                                      _preferredDate == null
                                          ? 'Preferred Date'
                                          : DateFormat('yyyy-MM-dd').format(_preferredDate!),
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: "nunito",
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 60),
                              backgroundColor: Colors.blue[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

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
                              minimumSize: Size(100, 60),
                              backgroundColor: Colors.blue[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
              )
      )],
          ),
        ),
      ),
    );
  }
}
