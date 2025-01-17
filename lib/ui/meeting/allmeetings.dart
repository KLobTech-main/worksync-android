import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modal/getallmeeeting.dart';
import '../../webservices/api.dart';

class AllMeetings extends StatefulWidget {
  final String? name;
  final String? email;

  AllMeetings({Key? key, this.name, this.email}) : super(key: key);

  @override
  _AllMeetingsState createState() => _AllMeetingsState();
}

class _AllMeetingsState extends State<AllMeetings> {
  late Future<List<GetAllMeeting>> _meetingsFuture;

  @override
  void initState() {
    super.initState();
    _meetingsFuture = ApiService.getAllMeetings(context);
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
          ' All Meetings',
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
      ),
      body: FutureBuilder<List<GetAllMeeting>>(
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
            return Center(child: Text('No meetings found.'));
          } else {
            List<GetAllMeeting> meetings = snapshot.data!;

            return ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                GetAllMeeting meeting = meetings[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: Icon(
                      Icons.meeting_room,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                    title: Text(
                      meeting.meetingTitle ?? 'No Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mode: ${meeting.meetingMode ?? 'N/A'},',
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          'Date: ${meeting.date ?? 'N/A'}',
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          'Time: ${meeting.scheduledTime ?? 'N/A'}',
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.people, size: 16),
                            SizedBox(width: 5),
                            Text(
                              '${meeting.participants?.length ?? 0} participants',
                              style: TextStyle(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.link,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                      ),
                      onPressed: () {
                        if (meeting.meetingLink != null) {}
                      },
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
}
