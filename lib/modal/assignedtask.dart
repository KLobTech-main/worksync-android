class AssignedTask {
  String? id;
  String? assignedBy;
  String? assignedTo;
  String? title;
  String? description;
  String? deadLine;
  String? status;

  AssignedTask(
      {this.id,
        this.assignedBy,
        this.assignedTo,
        this.title,
        this.description,
        this.deadLine,
        this.status});

  AssignedTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assignedBy = json['assignedBy'];
    assignedTo = json['assignedTo'];
    title = json['title'];
    description = json['description'];
    deadLine = json['deadLine'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assignedBy'] = this.assignedBy;
    data['assignedTo'] = this.assignedTo;
    data['title'] = this.title;
    data['description'] = this.description;
    data['deadLine'] = this.deadLine;
    data['status'] = this.status;
    return data;
  }
}