class TimeLogModelNew {
  final int totalWorkedHours;
  final int totalBreakMinutes;
  final int year;
  final int totalLateMinutes;
  final int totalOvertimeMinutes;
  final int month;

  TimeLogModelNew({
    required this.totalWorkedHours,
    required this.totalBreakMinutes,
    required this.year,
    required this.totalLateMinutes,
    required this.totalOvertimeMinutes,
    required this.month,
  });

  // Factory method to create a TimeLogModel instance from JSON
  factory TimeLogModelNew.fromJson(Map<String, dynamic> json) {
    return TimeLogModelNew(
      totalWorkedHours: json['totalWorkedHours'] ?? 0,
      totalBreakMinutes: json['totalBreakMinutes'] ?? 0,
      year: json['year'] ?? 0,
      totalLateMinutes: json['totalLateMinutes'] ?? 0,
      totalOvertimeMinutes: json['totalOvertimeMinutes'] ?? 0,
      month: json['month'] ?? 0,
    );
  }
}
