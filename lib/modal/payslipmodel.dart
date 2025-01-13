class PaySlipModel {
  String? id;
  String? email;
  String? payRunPeriod;
  String? payRunType;
  String? status;
  String? salary;
  String? netSalary;
  String? details;
  String? actions;
  String? paySlipUrl;

  PaySlipModel(
      {this.id,
        this.email,
        this.payRunPeriod,
        this.payRunType,
        this.status,
        this.salary,
        this.netSalary,
        this.details,
        this.actions,
        this.paySlipUrl});

  PaySlipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    payRunPeriod = json['payRunPeriod'];
    payRunType = json['payRunType'];
    status = json['status'];
    salary = json['salary'];
    netSalary = json['netSalary'];
    details = json['details'];
    actions = json['actions'];
    paySlipUrl = json['paySlipUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['payRunPeriod'] = this.payRunPeriod;
    data['payRunType'] = this.payRunType;
    data['status'] = this.status;
    data['salary'] = this.salary;
    data['netSalary'] = this.netSalary;
    data['details'] = this.details;
    data['actions'] = this.actions;
    data['paySlipUrl'] = this.paySlipUrl;
    return data;
  }
}