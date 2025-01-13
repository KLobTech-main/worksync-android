class LeaveSummaryModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? mobileNo;
  String? dob;
  AddressDetails1? addressDetails;
  String? role;
  List<String>? salaryOverview;
  SalaryDetails1? salaryDetails;
  List<EmergencyContact1>? emergencyContactDetails;
  bool? approvedByAdmin;
  AllLeaves? allLeaves;
  MonthlyLeaves? monthlyLeaves;
  BankDetailsOne1? bankDetails;

  LeaveSummaryModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.mobileNo,
      this.dob,
      this.addressDetails,
      this.role,
      this.salaryOverview,
      this.salaryDetails,
      this.emergencyContactDetails,
      this.approvedByAdmin,
      this.allLeaves,
      this.monthlyLeaves,
      this.bankDetails});

  LeaveSummaryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobileNo = json['mobileNo'];
    dob = json['dob'];
    addressDetails = json['addressDetails'] != null
        ? new AddressDetails1.fromJson(json['addressDetails'])
        : null;
    role = json['role'];
    salaryOverview = json['salaryOverview']?.cast<String>();
    salaryDetails = json['salaryDetails'] != null
        ? SalaryDetails1.fromJson(json['salaryDetails'])
        : null;
    if (json['emergencyContactDetails'] != null) {
      emergencyContactDetails = <EmergencyContact1>[];
      json['emergencyContactDetails'].forEach((v) {
        emergencyContactDetails!.add(new EmergencyContact1.fromJson(v));
      });
    }
    approvedByAdmin = json['approvedByAdmin'];
    allLeaves = json['allLeaves'] != null
        ? new AllLeaves.fromJson(json['allLeaves'])
        : null;
    monthlyLeaves = json['monthlyLeaves'] != null
        ? MonthlyLeaves.fromJson(json['monthlyLeaves'])
        : null;
    bankDetails = json['bankDetails'] != null
        ? new BankDetailsOne1.fromJson(json['bankDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobileNo'] = this.mobileNo;
    data['dob'] = this.dob;
    if (this.addressDetails != null) {
      data['addressDetails'] = this.addressDetails!.toJson();
    }
    data['role'] = this.role;
    data['salaryOverview'] = salaryOverview;
    if (salaryDetails != null) {
      data['salaryDetails'] = salaryDetails!.toJson();
    }
    if (this.emergencyContactDetails != null) {
      data['emergencyContactDetails'] =
          this.emergencyContactDetails!.map((v) => v.toJson()).toList();
    }
    data['approvedByAdmin'] = this.approvedByAdmin;
    if (this.allLeaves != null) {
      data['allLeaves'] = this.allLeaves!.toJson();
    }
    if (monthlyLeaves != null) {
      data['monthlyLeaves'] = monthlyLeaves!.toJson();
    }
    if (this.bankDetails != null) {
      data['bankDetails'] = this.bankDetails!.toJson();
    }
    return data;
  }
}

class SalaryDetails1 {
  String? payRunPeriod;
  String? houseRentAllowance;
  String? conveyanceAllowance;
  String? specialAllowance;
  String? medicalAllowance;

  SalaryDetails1({
    this.payRunPeriod,
    this.houseRentAllowance,
    this.conveyanceAllowance,
    this.specialAllowance,
    this.medicalAllowance,
  });

  SalaryDetails1.fromJson(Map<String, dynamic> json) {
    payRunPeriod = json['payRunPeriod'] ?? 'Not Available';
    houseRentAllowance = json['houseRentAllowance'] ?? '0';
    conveyanceAllowance = json['conveyanceAllowance'] ?? '0';
    specialAllowance = json['specialAllowance'] ?? '0';
    medicalAllowance = json['medicalAllowance'] ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payRunPeriod'] = payRunPeriod;
    data['houseRentAllowance'] = houseRentAllowance;
    data['conveyanceAllowance'] = conveyanceAllowance;
    data['specialAllowance'] = specialAllowance;
    data['medicalAllowance'] = medicalAllowance;
    return data;
  }
}

class AddressDetails1 {
  String? currentAddress;
  String? permanentAddress;

  AddressDetails1({this.currentAddress, this.permanentAddress});

  AddressDetails1.fromJson(Map<String, dynamic> json) {
    currentAddress = json['currentAddress'];
    permanentAddress = json['permanentAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentAddress'] = this.currentAddress;
    data['permanentAddress'] = this.permanentAddress;
    return data;
  }
}

class EmergencyContact1 {
  String? emergencyContactNo;
  String? emergencyContactName;
  String? relation;

  EmergencyContact1(
      {this.emergencyContactNo, this.emergencyContactName, this.relation});

  factory EmergencyContact1.fromJson(Map<String, dynamic> json) {
    return EmergencyContact1(
      emergencyContactNo: json['emergencyContactNo'],
      emergencyContactName: json['emergencyContactName'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emergencyContactNo': emergencyContactNo,
      'emergencyContactName': emergencyContactName,
      'relation': relation,
    };
  }
}

class AllLeaves {
  Map<String, double>? leaveTypeBalance;

  AllLeaves({this.leaveTypeBalance});

  AllLeaves.fromJson(Map<String, dynamic> json) {
    if (json['leaveTypeBalance'] != null) {
      leaveTypeBalance = (json['leaveTypeBalance'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (leaveTypeBalance != null) {
      data['leaveTypeBalance'] = leaveTypeBalance;
    }
    return data;
  }
}

class MonthlyLeaves {
  final Map<String, LeaveTypeBalance> leaveDetails;

  MonthlyLeaves({required this.leaveDetails});

  // Factory constructor to parse JSON
  factory MonthlyLeaves.fromJson(Map<String, dynamic> json) {
    final leaveDetails = <String, LeaveTypeBalance>{};
    json.forEach((month, details) {
      leaveDetails[month] =
          LeaveTypeBalance.fromJson(details['leaveTypeBalance']);
    });
    return MonthlyLeaves(leaveDetails: leaveDetails);
  }

  // Converts the object back to JSON
  Map<String, dynamic> toJson() {
    final leaveDetailsJson = <String, dynamic>{};
    leaveDetails.forEach((key, value) {
      leaveDetailsJson[key] = {'leaveTypeBalance': value.toJson()};
    });
    return leaveDetailsJson;
  }
}

class LeaveTypeBalance {
  final Map<String, double> leaveTypeBalance;

  LeaveTypeBalance({required this.leaveTypeBalance});

  // Factory constructor to parse JSON
  factory LeaveTypeBalance.fromJson(Map<String, dynamic> json) {
    return LeaveTypeBalance(leaveTypeBalance: Map<String, double>.from(json));
  }

  // Converts the object back to JSON
  Map<String, dynamic> toJson() {
    return leaveTypeBalance;
  }
}

class BankDetailsOne1 {
  String? accountHolderName;
  String? accountType;
  String? accountNumber;
  String? ifscCode;
  String? bankName;

  BankDetailsOne1(
      {this.accountHolderName,
      this.accountType,
      this.accountNumber,
      this.ifscCode,
      this.bankName});

  BankDetailsOne1.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['accountHolderName'];
    accountType = json['accountType'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountHolderName'] = this.accountHolderName;
    data['accountType'] = this.accountType;
    data['accountNumber'] = this.accountNumber;
    data['ifscCode'] = this.ifscCode;
    data['bankName'] = this.bankName;
    return data;
  }
}
