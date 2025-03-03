class TodosModel {
  String? id;
  String? userEmail;
  String? description;
  String? date;
  String? time;
  String? priority;
  String? category;
  bool isChecked;

  TodosModel({
    this.id,
    this.userEmail,
    this.description,
    this.date,
    this.time,
    this.priority,
    this.category,
    this.isChecked = false,
  });

  TodosModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userEmail = json['userEmail'],
        description = json['description'],
        date = json['date'],
        time = json['time'],
        priority = json['priority'],
        category = json['category'],
        isChecked = json['isChecked'] ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userEmail'] = userEmail;
    data['description'] = description;
    data['date'] = date;
    data['time'] = time;
    data['priority'] = priority;
    data['category'] = category;
    data['isChecked'] = isChecked;
    return data;
  }
}
