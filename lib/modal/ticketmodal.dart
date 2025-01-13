class TicketModal {
  String? id;
  String? email;
  String? title;
  String? description;
  String? status;
  String? createdAt;

  TicketModal(
      {this.id,
        this.email,
        this.title,
        this.description,
        this.status,
        this.createdAt});

  TicketModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}