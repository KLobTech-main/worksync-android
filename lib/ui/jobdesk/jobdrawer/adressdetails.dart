import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../modal/getuserbyemailmodel.dart';
import '../../../webservices/api.dart';

class AddressPage extends StatefulWidget {
  final String email;
  AddressPage({required this.email});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  AddressDetails? _addressDetails;
  bool _isLoading = true;

  void _fetchAddress() async {
    if (!mounted) return; // Check if the widget is still mounted
    setState(() => _isLoading = true);

    try {
      final userData = await ApiService.getUserByEmail(widget.email);
      if (!mounted) return; // Check again after the async call
      setState(() {
        _addressDetails = userData?.addressDetails;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Handle exceptions safely
      setState(() {
        _isLoading = false;
      });
      print('Error fetching address: $e');
    }
  }

  // Show bottom sheet for Add/Update
  void _showAddressForm({String? currentAddress, String? permanentAddress}) {
    TextEditingController currentController =
        TextEditingController(text: currentAddress);
    TextEditingController permanentController =
        TextEditingController(text: permanentAddress);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add/Update Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Color(0xFF57C9E7),
                    )),
                SizedBox(height: 10),
                TextFormField(
                  controller: currentController,
                  maxLength: 200,
                  decoration: InputDecoration(
                      labelText: "Current Address",
                      labelStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.grey
                              : Color(0xFF57C9E7),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.blue
                              : Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.white
                              : Color.fromARGB(255, 24, 28, 37)),
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your current address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: permanentController,
                  maxLength: 200,
                  decoration: InputDecoration(
                      labelText: "Permanent Address",
                      labelStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Color(0xFF1C1F26)
                            : Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.grey
                              : Color(0xFF57C9E7),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.blue
                              : Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.white
                              : Color.fromARGB(255, 24, 28, 37)),
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your permanent address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    try {
                      await ApiService.updateAddress(
                        widget.email,
                        currentController.text.trim(),
                        permanentController.text.trim(),
                      );
                      Navigator.pop(context); // Close the bottom sheet
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) {
                          _fetchAddress(); // Refresh address data
                        }
                      });
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "Failed to update address: $e",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        fontSize: 16.0,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.themeData.brightness == Brightness.light
                ? LinearGradient(
                    colors: [Colors.indigo.shade900, Colors.indigo.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null, // You can use null for no gradient in dark mode
            color: themeProvider.themeData.brightness == Brightness.dark
                ? Color.fromARGB(255, 24, 28, 37)
                : null, // This is used when brightness is dark for a solid color
          ),
        ),
        title: Text(
          'Address Details',
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        // actions: _addressDetails != null
        //     ? [
        //   IconButton(
        //     icon: Icon(Icons.edit),
        //     onPressed: () => _showAddressForm(
        //       currentAddress: _addressDetails?.currentAddress,
        //       permanentAddress: _addressDetails?.permanentAddress,
        //     ),
        //   ),
        // ]
        //     : [],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : _addressDetails != null
              ? _buildAddressCards()
              : _buildEmptyState(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        onPressed: () => _showAddressForm(),
        child: Icon(
          _addressDetails != null ? Icons.edit : Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAddressCards() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.location_on,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.blue
                      : Color(0xFF57C9E7),
                  size: 30),
              title: Text("Current Address"),
              subtitle: Text(
                _addressDetails?.currentAddress ?? "Not provided",
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.home, color: Colors.green, size: 30),
              title: Text("Permanent Address"),
              subtitle: Text(
                _addressDetails?.permanentAddress ?? "Not provided",
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "No Address Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          Text(
            "Tap the '+' button to add an address",
            style: TextStyle(
              fontSize: 14,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.grey
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
