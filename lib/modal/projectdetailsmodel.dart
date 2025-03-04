class ProjectModel {
  final String id;
  final String projectName;
  final String status;
  final String title;
  final String goal;
  final String objective;
  final String department;
  final List<List<String>> techStack;
  final List<String> teamMembers;
  final String clientInfo;
  final String deadLine;

  ProjectModel({
    required this.id,
    required this.projectName,
    required this.status,
    required this.title,
    required this.goal,
    required this.objective,
    required this.department,
    required this.techStack,
    required this.teamMembers,
    required this.clientInfo,
    required this.deadLine,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      projectName: json['projectName'] ?? '',
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      goal: json['goal'] ?? '',
      objective: json['objective'] ?? '',
      department: json['department'] ?? '',
      techStack: (json['techStack'] as List<dynamic>).map((e) => List<String>.from(e)).toList(),
      teamMembers: List<String>.from(json['teamMembers'] ?? []),
      clientInfo: json['clientInfo'] ?? '',
      deadLine: json['deadLine'] ?? '',
    );
  }
}

