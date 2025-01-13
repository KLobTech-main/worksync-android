class GetUserByEmailModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? mobileNo;
  String? dob;
  AddressDetails? addressDetails;
  String? role;
  List<String>? salaryOverview;
  SalaryDetails? salaryDetails;
  List<EmergencyContact>? emergencyContactDetails;
  bool? approvedByAdmin;
  AllLeaves? allLeaves;
  AllLeaves? monthlyLeaves;
  BankDetailsOne? bankDetails;

  GetUserByEmailModel(
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

  GetUserByEmailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobileNo = json['mobileNo'];
    dob = json['dob'];
    addressDetails = json['addressDetails'] != null
        ? new AddressDetails.fromJson(json['addressDetails'])
        : null;
    role = json['role'];
    salaryOverview = json['salaryOverview']?.cast<String>();
    salaryDetails = json['salaryDetails'] != null
        ? SalaryDetails.fromJson(json['salaryDetails'])
        : null;
    if (json['emergencyContactDetails'] != null) {
      emergencyContactDetails = <EmergencyContact>[];
      json['emergencyContactDetails'].forEach((v) {
        emergencyContactDetails!.add(new EmergencyContact.fromJson(v));
      });
    }
    approvedByAdmin = json['approvedByAdmin'];
    allLeaves = json['allLeaves'] != null
        ? new AllLeaves.fromJson(json['allLeaves'])
        : null;
    monthlyLeaves = json['monthlyLeaves'] != null
        ? AllLeaves.fromJson(json['monthlyLeaves']) // Deserialize as AllLeaves
        : null;
    bankDetails = json['bankDetails'] != null
        ? new BankDetailsOne.fromJson(json['bankDetails'])
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

class SalaryDetails {
  String? payRunPeriod;
  String? houseRentAllowance;
  String? conveyanceAllowance;
  String? specialAllowance;
  String? medicalAllowance;

  SalaryDetails({
    this.payRunPeriod,
    this.houseRentAllowance,
    this.conveyanceAllowance,
    this.specialAllowance,
    this.medicalAllowance,
  });

  SalaryDetails.fromJson(Map<String, dynamic> json) {
    payRunPeriod = json['payRunPeriod'];
    houseRentAllowance = json['houseRentAllowance'];
    conveyanceAllowance = json['conveyanceAllowance'];
    specialAllowance = json['specialAllowance'];
    medicalAllowance = json['medicalAllowance'];
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

class AddressDetails {
  String? currentAddress;
  String? permanentAddress;

  AddressDetails({this.currentAddress, this.permanentAddress});

  AddressDetails.fromJson(Map<String, dynamic> json) {
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

class EmergencyContact {
  String? emergencyContactNo;
  String? emergencyContactName;
  String? relation;

  EmergencyContact(
      {this.emergencyContactNo, this.emergencyContactName, this.relation});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
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
  int? sickLeave;
  int? casualLeave;
  int? paternity;
  int? optionalLeave;

  AllLeaves(
      {this.sickLeave, this.casualLeave, this.paternity, this.optionalLeave});

  AllLeaves.fromJson(Map<String, dynamic> json) {
    sickLeave = (json['sickLeave'] as num?)?.toInt();
    casualLeave = (json['casualLeave'] as num?)?.toInt();
    paternity = (json['paternity'] as num?)?.toInt();
    optionalLeave = (json['optionalLeave'] as num?)?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sickLeave'] = this.sickLeave;
    data['casualLeave'] = this.casualLeave;
    data['paternity'] = this.paternity;
    data['optionalLeave'] = this.optionalLeave;
    return data;
  }
}

class BankDetailsOne {
  String? accountHolderName;
  String? accountType;
  String? accountNumber;
  String? ifscCode;
  String? bankName;

  BankDetailsOne(
      {this.accountHolderName,
      this.accountType,
      this.accountNumber,
      this.ifscCode,
      this.bankName});

  BankDetailsOne.fromJson(Map<String, dynamic> json) {
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
