import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For pie chart



class ProjectDetailsPage extends StatefulWidget {
  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
        backgroundColor: Colors.indigo.shade900,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Name Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amazing App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [

                        Text("Goal",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold),),
                        Text(
                          'Deliver an amazing app experience',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text("Objectives",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold),),
                        Text(
                          'Improve user engagement, scalability, and performance ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Technologies and Team Members Section
              Text(
                'Tech Stack & Team Members',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // React Team
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.code, color: Colors.blue),
                  title: Text('React'),
                  subtitle: Text('Hemant, Ankit'),
                  trailing: Icon(Icons.group, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),

              // Flutter Team
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.smartphone, color: Colors.green),
                  title: Text('Flutter'),
                  subtitle: Text('Siddhi, Renu'),
                  trailing: Icon(Icons.group, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),

              // Backend Team
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.storage, color: Colors.redAccent),
                  title: Text('Backend'),
                  subtitle: Text('Ishan'),
                  trailing: Icon(Icons.group, color: Colors.grey),
                ),
              ),

              SizedBox(height: 24),
              // Team Members Section
              SizedBox(height: 24),
              Text(
                'Team Members',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 120, // Fixed height for horizontal scrolling
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Text('H', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 8),
                        Text('Hemant'),
                        Text('React', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Text('A', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 8),
                        Text('Ankit'),
                        Text('React', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Text('S', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 8),
                        Text('Siddhi'),
                        Text('Flutter', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Text('R', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 8),
                        Text('Renu'),
                        Text('Flutter', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: Text('I', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 8),
                        Text('Ishan'),
                        Text('Backend', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              // Client and Deadline Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Client: XYZ Corporation',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Deadline: 31st January 2025',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Navigation Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentsPage()),
                        );
                      },
                      icon: Icon(Icons.comment),
                      label: Text('View/Add Comments'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnalyticsPage()),
                        );
                      },
                      icon: Icon(Icons.pie_chart),
                      label: Text('View Analytics'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Comments Page
class CommentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text('Commenter Name'),
                      subtitle: Text('This is a sample comment.'),
                    ),
                  );
                },
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Add a comment...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                // Handle adding a new comment
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Analytics Page
class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Analytics'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Technology Usage',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 50,
                      color: Colors.blue,
                      title: 'React\n50%',
                      titleStyle: TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.green,
                      title: 'Flutter\n30%',
                      titleStyle: TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.redAccent,
                      title: 'Backend\n20%',
                      titleStyle: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Team Performance: 80% Completion',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

