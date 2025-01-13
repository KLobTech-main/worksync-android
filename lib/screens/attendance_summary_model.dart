class AttendanceSummaryModel {
  String? id;
  String? name;
  String? email;
  String? punchInTime;
  String? punchOutTime;
  String? date;
  int? overTime;
  int? lateTime;
  int? totalWorkingHours;
  String? lunchStartTime;
  String? lunchEndTime;
  String? teaStartTime;
  String? teaEndTime;

  AttendanceSummaryModel(
      {this.id,
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
      this.teaEndTime});

  AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    punchInTime = json['punchInTime'];
    punchOutTime = json['punchOutTime'];
    date = json['date'];
    overTime = json['overTime'];
    lateTime = json['lateTime'];
    totalWorkingHours = json['totalWorkingHours'];
    lunchStartTime = json['lunchStartTime'];
    lunchEndTime = json['lunchEndTime'];
    teaStartTime = json['teaStartTime'];
    teaEndTime = json['teaEndTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['punchInTime'] = this.punchInTime;
    data['punchOutTime'] = this.punchOutTime;
    data['date'] = this.date;
    data['overTime'] = this.overTime;
    data['lateTime'] = this.lateTime;
    data['totalWorkingHours'] = this.totalWorkingHours;
    data['lunchStartTime'] = this.lunchStartTime;
    data['lunchEndTime'] = this.lunchEndTime;
    data['teaStartTime'] = this.teaStartTime;
    data['teaEndTime'] = this.teaEndTime;
    return data;
  }
}
