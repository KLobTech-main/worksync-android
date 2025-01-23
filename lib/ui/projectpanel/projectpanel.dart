// Flutter UI for Project Panel
import 'package:dass/ui/projectpanel/projectdetailspage.dart';
import 'package:flutter/material.dart';

class ProjectPanelPage extends StatefulWidget {
  @override
  State<ProjectPanelPage> createState() => _ProjectPanelPageState();
}

class _ProjectPanelPageState extends State<ProjectPanelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Column(
        children: [
          // Search and Filter Options
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search projects...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(Icons.search, color: Colors.indigo.shade900),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Project List (Grid View)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                 childAspectRatio: 4 / 3,
              ),
              itemCount: 6, // Replace with your project count
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailsPage(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon and Project Name in Row
                          Row(
                            children: [
                              Icon(
                                Icons.folder,
                                color: Colors.indigo.shade900,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Project Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.indigo.shade900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          // Status below project name
                          Text(
                            'Status: On Going', // Dynamic status text
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          // Three-dot menu aligned at the bottom-right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  // Handle status changes here
                                  print("Status changed to $value");
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'On Going',
                                    child: Row(
                                      children: [
                                        Icon(Icons.play_arrow, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text('On Going'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'On Hold',
                                    child: Row(
                                      children: [
                                        Icon(Icons.pause, color: Colors.amber),
                                        SizedBox(width: 8),
                                        Text('On Hold'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Terminated',
                                    child: Row(
                                      children: [
                                        Icon(Icons.close, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Terminated'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'Completed',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('Completed'),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}






