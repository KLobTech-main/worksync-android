import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/getuserbyemailmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../webservices/api.dart';

class EmergencyContactPage extends StatefulWidget {
  final String email;

  EmergencyContactPage({required this.email});

  @override
  _EmergencyContactPageState createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  List<EmergencyContact>? emergencyContacts;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Function to get Emergency Contacts
  Future<void> getEmergencyContacts() async {
    try {
      var user = await ApiService.getUserByEmail(widget.email, context);
      setState(() {
        // If emergencyContactDetails is null, set it to an empty list
        emergencyContacts = user?.emergencyContactDetails ?? [];
      });
    } catch (e) {
      print('Error fetching emergency contacts: $e');
      // Handle error case by setting emergencyContacts to an empty list
      setState(() {
        emergencyContacts = [];
      });
    }
  }

  // Function to validate input fields
  bool validateFields(
      TextEditingController nameController,
      TextEditingController numberController,
      TextEditingController relationController) {
    if (nameController.text.isEmpty ||
        numberController.text.isEmpty ||
        relationController.text.isEmpty) {
      Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg: "Please fill all fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(numberController.text)) {
      Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg: "Please enter a valid 10-digit phone number.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    return true;
  }

  // Function to show Add/Update Dialog
  void showAddUpdateDialog({EmergencyContact? contact}) {
    final TextEditingController nameController =
        TextEditingController(text: contact?.emergencyContactName ?? '');
    final TextEditingController numberController =
        TextEditingController(text: contact?.emergencyContactNo ?? '');
    final TextEditingController relationController =
        TextEditingController(text: contact?.relation ?? '');
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF1C1F26),
        title: Text(
          contact == null
              ? 'Add Emergency Contact'
              : 'Update Emergency Contact',
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.grey[800]
                      : Colors.grey[400],
                ),
              ),
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.grey[800]
                      : Colors.grey[400],
                ),
              ),
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            TextField(
              controller: relationController,
              decoration: InputDecoration(
                labelText: 'Relation',
                labelStyle: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.grey[800]
                      : Colors.grey[400],
                ),
              ),
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo
                    : const Color(0xFF57C9E7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!validateFields(
                  nameController, numberController, relationController)) {
                return;
              }

              try {
                bool success;
                if (contact == null) {
                  success = await ApiService.postEmergencyContact(
                    widget.email,
                    EmergencyContact(
                      emergencyContactName: nameController.text,
                      emergencyContactNo: numberController.text,
                      relation: relationController.text,
                    ),
                    context,
                  );
                } else {
                  success = await ApiService.postEmergencyContact(
                    widget.email,
                    EmergencyContact(
                      emergencyContactName: nameController.text,
                      emergencyContactNo: numberController.text,
                      relation: relationController.text,
                    ),
                    context,
                  );
                }

                if (success) {
                  Fluttertoast.showToast(
                    timeInSecForIosWeb: 2,
                    msg: contact == null
                        ? 'Contact added successfully'
                        : 'Contact updated successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : const Color(0xFF57C9E7),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  getEmergencyContacts();
                }
                Navigator.pop(context);
              } catch (e) {
                Fluttertoast.showToast(
                  timeInSecForIosWeb: 2,
                  msg: 'Error: $e',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : const Color(0xFF57C9E7),
            ),
            child: Text(contact == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Function to delete emergency contact
  void deleteEmergencyContact(String name) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    try {
      bool success =
          await ApiService.deleteEmergencyContact(widget.email, name, context);
      if (success) {
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: 'Contact deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : const Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );

        getEmergencyContacts();
      }
    } catch (e) {
      Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg: 'Error deleting contact: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getEmergencyContacts();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : const Color(0xFF1C1F26),
      key: scaffoldMessengerKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.themeData.brightness == Brightness.light
                ? LinearGradient(
                    colors: [Colors.indigo.shade900, Colors.indigo.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: themeProvider.themeData.brightness == Brightness.dark
                ? const Color.fromARGB(255, 24, 28, 37)
                : null,
          ),
        ),
        title: Text(
          'Emergency Contacts',
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : const Color(0xFF57C9E7),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF57C9E7),
        ),
      ),
      body: emergencyContacts == null
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : emergencyContacts!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.contact_phone,
                          size: 60, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        'No emergency contacts added yet.',
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // ElevatedButton(
                      //   onPressed: () => showAddUpdateDialog(),
                      //   child: Text(
                      //     'Add Emergency Contact',
                      //     style: TextStyle(
                      //       color: themeProvider.themeData.brightness ==
                      //               Brightness.light
                      //           ? Colors.white
                      //           : Colors.black,
                      //     ),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor:
                      //           themeProvider.themeData.brightness ==
                      //                   Brightness.light
                      //               ? Colors.indigo.shade900
                      //               : Color(0xFF57C9E7)),
                      // ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: emergencyContacts!.length,
                  itemBuilder: (context, index) {
                    final contact = emergencyContacts![index];
                    return Card(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.white
                              : Color.fromARGB(255, 21, 24, 30),
                      child: ListTile(
                        title: Text(
                          contact.emergencyContactName ?? 'Unknown',
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          contact.emergencyContactNo ?? 'No Number',
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey[400],
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteEmergencyContact(
                                contact.emergencyContactName!);
                          },
                        ),
                        onTap: () {
                          showAddUpdateDialog(contact: contact);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddUpdateDialog(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : const Color(0xFF57C9E7),
      ),
    );
  }
}
