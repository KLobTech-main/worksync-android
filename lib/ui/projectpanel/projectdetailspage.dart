import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../modal/projectdetailsmodel.dart'; // For pie chart


class ProjectDetailsPage extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.projectName), // Dynamic Project Name
        backgroundColor: Colors.indigo.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Title & Goal
            _buildSectionCard(
              title: "Title",
              content: project.title,
              icon: Icons.title,
            ),
            _buildSectionCard(
              title: "Goal",
              content: project.goal,
              icon: Icons.flag,
            ),
            _buildSectionCard(
              title: "Objective",
              content: project.objective,
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 20),

            // Tech Stack & Team Members
            Text("Tech Stack & Team Members", style: _sectionTitleStyle),
            const SizedBox(height: 10),

            ...project.techStack.map((tech) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(Icons.code, color: Colors.blue),
                  title: Text(tech[0]),
                  subtitle: Text(tech.sublist(1).join(', ')), // Shows team members
                  trailing: Icon(Icons.group, color: Colors.grey),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // Team Members as Avatars
            Text("Team Members", style: _sectionTitleStyle),
            const SizedBox(height: 10),
            _buildTeamMembers(),

            const SizedBox(height: 20),

            // Client & Deadline
            _buildSectionCard(
              title: "Client Information",
              content: project.clientInfo,
              icon: Icons.business,
            ),
            _buildSectionCard(
              title: "Deadline",
              content: project.deadLine,
              icon: Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo.shade900),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content.isNotEmpty ? content : "N/A"),
      ),
    );
  }

  Widget _buildTeamMembers() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: project.teamMembers.map((member) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.indigo,
                  child: Text(member[0], style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Text(member),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  static const TextStyle _sectionTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}



