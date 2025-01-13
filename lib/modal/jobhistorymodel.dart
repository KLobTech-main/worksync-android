class JobHistoryModel {
  String? id;
  String? email;
  String? department;
  WorkShift? workShift;
  String? designation;
  String? employmentStatus;
  String? joiningDate;

  JobHistoryModel(
      {this.id,
        this.email,
        this.department,
        this.workShift,
        this.designation,
        this.employmentStatus,
        this.joiningDate});

  JobHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    department = json['department'];
    workShift = json['workShift'] != null
        ? new WorkShift.fromJson(json['workShift'])
        : null;
    designation = json['designation'];
    employmentStatus = json['employmentStatus'];
    joiningDate = json['joiningDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['department'] = this.department;
    if (this.workShift != null) {
      data['workShift'] = this.workShift!.toJson();
    }
    data['designation'] = this.designation;
    data['employmentStatus'] = this.employmentStatus;
    data['joiningDate'] = this.joiningDate;
    return data;
  }
}

class WorkShift {
  String? shiftType;
  String? profile;

  WorkShift({this.shiftType, this.profile});

  WorkShift.fromJson(Map<String, dynamic> json) {
    shiftType = json['shiftType'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftType'] = this.shiftType;
    data['profile'] = this.profile;
    return data;
  }
}