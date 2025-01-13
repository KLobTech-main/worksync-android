class AllUsers {
  String? id;
  String? name;
  String? email;
  String? password;
  String? mobileNo;
  String? dob;
  AddressDetails? addressDetails;
  String? role;
  Map<String, dynamic>? salaryOverview; // Updated to Map<String, dynamic> to handle null
  Map<String, dynamic>? salaryDetails;  // Updated to Map<String, dynamic> to handle null
  EmergencyContactAll? emergencyContactDetails;
  bool? approvedByAdmin;
  Map<String, dynamic>? allLeaves; // Updated to Map<String, dynamic> to handle null
  BankDetails? bankDetails;

  AllUsers(
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
        this.bankDetails});

  AllUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobileNo = json['mobileNo'];
    dob = json['dob'];

    // Handling addressDetails, if present
    if (json['addressDetails'] != null) {
      addressDetails = AddressDetails.fromJson(json['addressDetails']);
    }

    role = json['role'];

    // Handle null for salaryOverview and salaryDetails
    salaryOverview = json['salaryOverview'] != null ? json['salaryOverview'] as Map<String, dynamic> : null;
    salaryDetails = json['salaryDetails'] != null ? json['salaryDetails'] as Map<String, dynamic> : null;

    emergencyContactDetails = json['emergencyContactDetails'] != null
        ? EmergencyContactAll.fromJson(json['emergencyContactDetails'])
        : null;

    approvedByAdmin = json['approvedByAdmin'];

    // Handle null for allLeaves
    allLeaves = json['allLeaves'] != null ? json['allLeaves'] as Map<String, dynamic> : null;

    bankDetails = json['bankDetails'] != null
        ? BankDetails.fromJson(json['bankDetails'])
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

    if (this.salaryOverview != null) {
      data['salaryOverview'] = this.salaryOverview!;
    }

    if (this.salaryDetails != null) {
      data['salaryDetails'] = this.salaryDetails!;
    }

    if (this.emergencyContactDetails != null) {
      data['emergencyContactDetails'] = this.emergencyContactDetails!.toJson();
    }

    data['approvedByAdmin'] = this.approvedByAdmin;

    if (this.allLeaves != null) {
      data['allLeaves'] = this.allLeaves!;
    }

    if (this.bankDetails != null) {
      data['bankDetails'] = this.bankDetails!.toJson();
    }

    return data;
  }
}

class BankDetails {
  String? accountHolderName;
  String? accountType;
  String? accountNumber;
  String? ifscCode;
  String? bankName;

  BankDetails(
      {this.accountHolderName,
        this.accountType,
        this.accountNumber,
        this.ifscCode,
        this.bankName});

  BankDetails.fromJson(Map<String, dynamic> json) {
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

class EmergencyContactAll {
  String? emergencyContactNo;
  String? emergencyContactName;
  String? relation;

  EmergencyContactAll({this.emergencyContactNo, this.emergencyContactName, this.relation});

  factory EmergencyContactAll.fromJson(Map<String, dynamic> json) {
    return EmergencyContactAll(
      emergencyContactNo: json['emergencyContactNo'], // Correct key
      emergencyContactName: json['emergencyContactName'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emergencyContactNo': emergencyContactNo, // Match API key
      'emergencyContactName': emergencyContactName,
      'relation': relation,
    };
  }
}

class AddressDetails {
  String? currentAddress;
  String? permanentAddress;

  AddressDetails({this.currentAddress, this.permanentAddress});

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      currentAddress: json['currentAddress'],
      permanentAddress: json['permanentAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentAddress': currentAddress,
      'permanentAddress': permanentAddress,
    };
  }
}



