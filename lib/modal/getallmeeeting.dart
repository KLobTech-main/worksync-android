class GetAllMeeting {
  String? id;
  String? meetingTitle;
  String? description;
  String? meetingMode;
  List<String>? participants;
  String? duration;
  String? date;
  String? scheduledTime;
  String? meetingLink;

  GetAllMeeting(
      {this.id,
        this.meetingTitle,
        this.description,
        this.meetingMode,
        this.participants,
        this.duration,
        this.date,
        this.scheduledTime,
        this.meetingLink});

  GetAllMeeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingTitle = json['meetingTitle'];
    description = json['description'];
    meetingMode = json['meetingMode'];
    participants = json['participants'] != null
        ? List<String>.from(json['participants'])
        : []; // If null, set it as an empty list
    duration = json['duration'];
    date = json['date'];
    scheduledTime = json['scheduledTime'];
    meetingLink = json['meetingLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meetingTitle'] = this.meetingTitle;
    data['description'] = this.description;
    data['meetingMode'] = this.meetingMode;
    data['participants'] = this.participants;
    data['duration'] = this.duration;
    data['date'] = this.date;
    data['scheduledTime'] = this.scheduledTime;
    data['meetingLink'] = this.meetingLink;
    return data;
  }
}