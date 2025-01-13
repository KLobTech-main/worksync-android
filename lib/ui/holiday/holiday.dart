import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarHolidayScreen extends StatefulWidget {
  @override
  _CalendarHolidayScreenState createState() => _CalendarHolidayScreenState();
}

class _CalendarHolidayScreenState extends State<CalendarHolidayScreen> {
  final List<Map<String, String>> holidays = [
    {"date": "1 Jan", "name": "New Year's Day", "type": "Restricted Holiday"},
    {"date": "13 Jan", "name": "Lohri", "type": "Observance"},
    {"date": "14 Jan", "name": "Pongal", "type": "Restricted Holiday"},
    {"date": "14 Jan", "name": "Makar Sankranti", "type": "Restricted Holiday"},
    {"date": "26 Jan", "name": "Republic Day", "type": "Gazetted Holiday"},
    {"date": "19 Feb", "name": "Shivaji Jayanti", "type": "Restricted Holiday"},
    {
      "date": "23 Feb",
      "name": "Maharishi Dayanand Saraswati Jayanti",
      "type": "Restricted Holiday"
    },
    {"date": "26 Feb", "name": "Maha Shivaratri", "type": "Gazetted Holiday"},
    {"date": "14 Mar", "name": "Holi", "type": "Gazetted Holiday"},
    {
      "date": "31 Mar",
      "name": "Ramzan Id/Eid-ul-Fitar",
      "type": "Gazetted Holiday"
    },
    {"date": "6 Apr", "name": "Rama Navami", "type": "Restricted Holiday"},
    {"date": "10 Apr", "name": "Mahavir Jayanti", "type": "Gazetted Holiday"},
    {"date": "18 Apr", "name": "Good Friday", "type": "Gazetted Holiday"},
    {
      "date": "1 May",
      "name": "International Worker's Day",
      "type": "Observance"
    },
    {
      "date": "9 Aug",
      "name": "Raksha Bandhan (Rakhi)",
      "type": "Restricted Holiday"
    },
    {"date": "15 Aug", "name": "Independence Day", "type": "Gazetted Holiday"},
    {"date": "16 Aug", "name": "Janmashtami", "type": "Restricted Holiday"},
    {
      "date": "27 Aug",
      "name": "Ganesh Chaturthi",
      "type": "Restricted Holiday"
    },
    {"date": "5 Sep", "name": "Milad un-Nabi", "type": "Gazetted Holiday"},
    {"date": "1 Oct", "name": "Maha Navami", "type": "Gazetted Holiday"},
    {
      "date": "1 Oct",
      "name": "Mahatma Gandhi Jayanti",
      "type": "Gazetted Holiday"
    },
    {"date": "20 Oct", "name": "Diwali/Deepavali", "type": "Gazetted Holiday"},
    {"date": "22 Oct", "name": "Govardhan Puja", "type": "Restricted Holiday"},
    {"date": "25 Dec", "name": "Christmas", "type": "Gazetted Holiday"},
    {"date": "25 Dec", "name": "New Year's Eve", "type": "Observance Holiday"},
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26), // Dark theme background
      appBar: AppBar(
        title: Text(
          "Holidays",
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
                : null, // No gradient for dark theme
            color: themeProvider.themeData.brightness == Brightness.dark
                ? Color.fromARGB(255, 24, 28, 37)
                : null, // Dark theme solid color
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
      ),
      body: ListView.builder(
        itemCount: holidays.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final holiday = holidays[index];
          final isGazetted = holiday["type"] == "Gazetted Holiday";
          final isRestricted = holiday["type"] == "Restricted Holiday";
          final tagColor = isGazetted
              ? Colors.green.shade100
              : isRestricted
                  ? Colors.blue.shade100
                  : Colors.orange.shade100;

          final tagTextColor = isGazetted
              ? Colors.green.shade900
              : isRestricted
                  ? Colors.blue.shade900
                  : Colors.orange.shade900;

          return Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Container(
              decoration: BoxDecoration(
                gradient: themeProvider.themeData.brightness == Brightness.light
                    ? LinearGradient(
                        colors: [Colors.indigo.shade100, Colors.indigo.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          Color.fromARGB(255, 24, 28, 37),
                          Color.fromARGB(255, 24, 28, 37)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    // Circular Date Display
                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7), // Dark theme background
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            holiday["date"]!.split(' ')[0], // Day
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            holiday["date"]!.split(' ')[1], // Month
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),

                    // Holiday Name and Type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holiday["name"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Chip(
                                label: Text(
                                  holiday["type"]!,
                                  style: TextStyle(
                                    color: tagTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: tagColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Icon for Type
                    Icon(
                      isGazetted
                          ? Icons.star
                          : isRestricted
                              ? Icons.lock
                              : Icons.event,
                      color: isGazetted
                          ? Colors.green
                          : isRestricted
                              ? Colors.blue
                              : Colors.orange,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
