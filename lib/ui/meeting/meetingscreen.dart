import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/meeting/allmeetings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modal/meetingsmodel.dart';
import '../../webservices/api.dart';
import 'meetingdetails.dart';
import 'newmeeting.dart';

class MeetingListScreen extends StatefulWidget {
  final String? name;
  final String? email;

  MeetingListScreen({Key? key, this.name, this.email}) : super(key: key);
  @override
  State<MeetingListScreen> createState() => _MeetingListScreenState();
}

class _MeetingListScreenState extends State<MeetingListScreen> {
  late Future<List<MeetingModal>> _meetingsFuture;

  @override
  void initState() {
    super.initState();
    _meetingsFuture = ApiService.getMeetings(widget.email!, context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          'Meetings',
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
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllMeetings(
                            name: widget.name,
                            email: widget.email,
                          )));
            },
            child: Text(
              'All Meetings',
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF57C9E7),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<MeetingModal>>(
        future: _meetingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildNoMeetingsUI(context);
          } else {
            return _buildMeetingsList(snapshot.data!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMeetingScreen(
                name: widget.name,
                email: widget.email,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNoMeetingsUI(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'No meetings scheduled',
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.grey
                  : Colors.white,
            ),
          ),
          SizedBox(height: 20),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor:
          //         themeProvider.themeData.brightness == Brightness.light
          //             ? Colors.indigo.shade900
          //             : Color(0xFF57C9E7),
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CreateMeetingScreen(
          //           name: widget.name,
          //           email: widget.email,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Text(
          //     'Create Meeting',
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMeetingsList(List<MeetingModal> meetings) {
    return ListView.builder(
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MeetingDetailsScreen(meeting: meeting),
              //   ),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetingDetailsScreen(
                    meeting: meeting,
                    onMeetingUpdated: () {
                      setState(() {
                        _meetingsFuture =
                            ApiService.getMeetings(widget.email!, context);
                      });
                    },
                  ),
                ),
              );
            },
            title: Text(meeting.meetingTitle ?? 'Meeting Title'),
            subtitle: Column(
              children: [
                Text('Date: ${meeting.date ?? ''}'),
                SizedBox(
                  height: 10,
                ),
                Text('Mode: ${meeting.meetingMode ?? ''}'),
                SizedBox(
                  height: 10,
                ),
                Text('Duration: ${meeting.duration ?? ''}'),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}
