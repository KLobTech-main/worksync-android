// Flutter UI for Project Panel
import 'package:dass/ui/projectpanel/projectdetailspage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../modal/projectdetailsmodel.dart';
import '../../webservices/api.dart';
class ProjectPanelPage extends StatefulWidget {
  @override
  State<ProjectPanelPage> createState() => _ProjectPanelPageState();
}

class _ProjectPanelPageState extends State<ProjectPanelPage> {
  List<ProjectModel> _projects = [];
  List<ProjectModel> _filteredProjects = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    try {
      List<ProjectModel?>? projects = await ApiService.getProjects(context);
      if (projects != null) {
        setState(() {
          _projects = projects.whereType<ProjectModel>().toList();
          _filteredProjects = _projects;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }


  void _searchProjects(String query) {
    setState(() {
      _filteredProjects = _projects
          .where((project) => project.projectName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
                    onChanged: _searchProjects,
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
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: _fetchProjects, // Reload data
                  ),
                ),
              ],
            ),
          ),

          // Project List (Grid View)
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : _hasError
                ? Center(child: Text("Failed to load projects")) // Handle error
                : _filteredProjects.isEmpty
                ? Center(child: Text("No projects found")) // Handle empty state
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 4 / 3,
              ),
              itemCount: _filteredProjects.length,
              itemBuilder: (context, index) {
                ProjectModel project = _filteredProjects[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailsPage(project: project),
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
                                  project.projectName, // Actual project name
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






