class AttendanceDetailsModel {
  int? totalBreakTime;
  Attendance? attendance;

  AttendanceDetailsModel({this.totalBreakTime, this.attendance});

  AttendanceDetailsModel.fromJson(Map<String, dynamic> json) {
    totalBreakTime = json['totalBreakTime'];
    attendance = json['attendance'] != null
        ? Attendance.fromJson(json['attendance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalBreakTime'] = totalBreakTime;
    if (attendance != null) {
      data['attendance'] = attendance!.toJson();
    }
    return data;
  }
}

class Attendance {
  String? id;
  String? name;
  String? email;
  String? punchInTime;
  String? punchOutTime;
  String? date;
  int? overTime;
  int? lateTime;
  int? totalWorkingHours;
  String? lunchStartTime; // Changed from Null to String?
  String? lunchEndTime; // Changed from Null to String?
  String? teaStartTime;
  String? teaEndTime; // Changed from Null to String?

  Attendance({
    this.id,
    this.name,
    this.email,
    this.punchInTime,
    this.punchOutTime,
    this.date,
    this.overTime,
    this.lateTime,
    this.totalWorkingHours,
    this.lunchStartTime,
    this.lunchEndTime,
    this.teaStartTime,
    this.teaEndTime,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    punchInTime = json['punchInTime'];
    punchOutTime = json['punchOutTime'];
    date = json['date'];
    overTime = json['overTime'];
    lateTime = json['lateTime'];
    totalWorkingHours = json['totalWorkingHours'];
    lunchStartTime = json['lunchStartTime']; // Nullable String
    lunchEndTime = json['lunchEndTime']; // Nullable String
    teaStartTime = json['teaStartTime']; // Nullable String
    teaEndTime = json['teaEndTime']; // Nullable String
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['punchInTime'] = punchInTime;
    data['punchOutTime'] = punchOutTime;
    data['date'] = date;
    data['overTime'] = overTime;
    data['lateTime'] = lateTime;
    data['totalWorkingHours'] = totalWorkingHours;
    data['lunchStartTime'] = lunchStartTime;
    data['lunchEndTime'] = lunchEndTime;
    data['teaStartTime'] = teaStartTime;
    data['teaEndTime'] = teaEndTime;
    return data;
  }
}
