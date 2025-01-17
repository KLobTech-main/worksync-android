import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/meeting/editmeeting.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../modal/meetingsmodel.dart';

class MeetingDetailsScreen extends StatefulWidget {
  final MeetingModal meeting;
  final VoidCallback? onMeetingUpdated;

  MeetingDetailsScreen({required this.meeting, this.onMeetingUpdated});

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  void _rescheduleMeeting(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: themeProvider.themeData.brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  primaryColor: Colors.blue,
                  hintColor: Colors.blue,
                  buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                  ),
                )
              : ThemeData.light().copyWith(
                  primaryColor: Color(0xFF57C9E7),
                  hintColor: Color(0xFF57C9E7),
                  buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                  ),
                ),
          child: child ?? Container(),
        );
      },
    );

    if (newTime != null) {
      final newTimeString = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        newTime.hour,
        newTime.minute,
      ).toIso8601String();

      try {
        // Call the API without expecting a return value.
        await ApiService.rescheduleMeeting(
            context, widget.meeting.id ?? '', newTimeString);

        Fluttertoast.showToast(
          msg: "Meeting rescheduled successfully!",
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
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      try {
        await ApiService.rescheduleMeeting(
            context, widget.meeting.id ?? '', newTimeString);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meeting rescheduled successfully!')),
        );
        if (widget.onMeetingUpdated != null)
          widget.onMeetingUpdated!(); // Notify parent
        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _updateMeetingStatus(BuildContext context, String status) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    try {
      // Call the API without expecting a return value.
      await ApiService.updateMeetingStatus(
          context, widget.meeting.id ?? '', status);

      Fluttertoast.showToast(
        msg: "Meeting status updated to $status",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _editMeeting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMeetingScreen(meeting: widget.meeting),
      ),
    );
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
          widget.meeting.meetingTitle ?? 'Meeting Details',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.meeting.meetingTitle ?? 'Meeting Title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Make Open') {
                      _updateMeetingStatus(context, 'Open');
                    } else if (value == 'Make Close') {
                      _updateMeetingStatus(context, 'Close');
                    }
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'Make Open',
                      child: Text('Make Open'),
                    ),
                    PopupMenuItem(
                      value: 'Make Close',
                      child: Text('Make Close'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${widget.meeting.date ?? ''}',
              style: TextStyle(
                fontSize: 18,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.grey
                    : Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Participants:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            SizedBox(height: 10),
            widget.meeting.participants != null
                ? Column(
                    children: widget.meeting.participants!
                        .map((participant) => Text(
                              participant,
                              style: TextStyle(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ))
                        .toList(),
                  )
                : Text(
                    'No participants',
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                    ),
                  ),
            SizedBox(height: 30),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _rescheduleMeeting(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                        ),
                      ),
                      child: Text('Reschedule'),
                    ),

                    // ElevatedButton(
                    //   onPressed: () => _updateMeetingStatus(context, 'Open'),
                    //   child: Text('Mark Open'),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () => _updateMeetingStatus(context, 'Close'),
                    //   child: Text('Mark Close'),
                    // ),

                    ElevatedButton(
                      onPressed: () => _editMeeting(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                        ),
                      ),
                      child: Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
