class AppValidator {
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatedPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length != 11) {
      return 'Please enter an digit password';
    }
    return null;
  }

  String? isEmptyCheck(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ('Please fill details');
    }

    return null;
  }

  String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a role';
    }

    return null;
  }

  String? validateJoinDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a join date';
    }

    return null;
  }

  String? validateDepartment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a department';
    }

    return null;
  }

  String? validateMobileNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a mobile number';
    }

    final RegExp mobileRegExp = RegExp(r'^[6-9]\d{9}$');
    if (!mobileRegExp.hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }

    return null;
  }

  // address_validator.dart

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address cannot be empty';
    }
    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters long';
    }
    return null; // No error
  }
}
