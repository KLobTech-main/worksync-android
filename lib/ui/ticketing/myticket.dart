import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/ticketing/raiseticket.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../webservices/api.dart';

class MyTicketsPage extends StatefulWidget {
  final String? name;
  final String? email;

  const MyTicketsPage({Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  _MyTicketsPageState createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  late Future<List<dynamic>> _tickets;

  @override
  void initState() {
    super.initState();
    _tickets = _fetchTickets();
  }

  void _refreshTickets() {
    setState(() {
      _tickets = _fetchTickets();
    });
  }

  Future<List<dynamic>> _fetchTickets() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    try {
      return await ApiService.getTickets(widget.email!, context);
    } catch (e) {
      print("Error fetching tickets: $e");

      Fluttertoast.showToast(
        msg: "Error fetching tickets: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return []; // Return an empty list if an error occurs
    }
  }

  void _showEditDialog(Map<String, dynamic> ticket) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final _titleController = TextEditingController(text: ticket['title']);
    final _descriptionController =
        TextEditingController(text: ticket['description']);
    String _priority = ticket['priority'] ?? 'Low';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Ticket',
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.6)
                              : Colors.white.withOpacity(0.6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.6)
                              : Colors.white.withOpacity(0.6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                  value: _priority,
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _priority = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.6)
                              : Colors.white.withOpacity(0.6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : Color(0xFF57C9E7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                style:
                TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : Color(0xFF57C9E7),
                );

                try {
                  final response = await ApiService.editTicket(
                      ticketId: ticket['id'],
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority,
                      context);

                  if (response.statusCode == 200) {
                    // Close the dialog
                    _refreshTickets();
                    Navigator.pop(context);

                    // Show toast message using root ScaffoldMessenger

                    Fluttertoast.showToast(
                      msg: 'Edited successfully!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    // Refresh UI
                    _refreshTickets();
                  }
                  else if (response.statusCode == 404) {
                    Fluttertoast.showToast(
                      msg: 'Ticket Not Found',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                  else if (response.statusCode == 401) {
                    Fluttertoast.showToast(
                      msg: 'Invalid Or Expired Token',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                  else {
                    Fluttertoast.showToast(
                      msg: 'Failed to update ticket: ${response.body}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Error updating ticket: $e',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    debugPrint("3 name ${widget.name}, email ${widget.email}");
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          "My Tickets",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
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
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF57C9E7),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RaiseTicketPage(
                    name: widget.name,
                    email: widget.email,
                    onTicketRaised: _refreshTickets,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _tickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              "No tickets found!",
              style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
            ));
          } else {
            final tickets = snapshot.data!;
            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: themeProvider.themeData.brightness == Brightness.dark
                      ? Color(0xFF2E2E2E)
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_number,
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Color(0xFF57C9E7),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ticket['title'] ?? 'Untitled Ticket',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.indigo.shade900
                                    : Color(0xFF57C9E7),
                              ),
                              onPressed: () => _showEditDialog(ticket),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          ticket['description'] ?? 'No description provided.',
                          style: TextStyle(
                              fontSize: 14,
                              color: themeProvider.themeData.brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ${ticket['status'] ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: ticket['status'] == 'OPEN'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              _formatDateTime(ticket['createdAt']) ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: themeProvider.themeData.brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
  String _formatDateTime(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) {
      return "No Date Available";
    }

    try {
      // Parse the ISO string to DateTime
      DateTime dateTime = DateTime.parse(isoDate);

      // Format the date and time using intl
      String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      return formattedDate;
    } catch (e) {
      return "Invalid Date Format";
    }
  }

}
