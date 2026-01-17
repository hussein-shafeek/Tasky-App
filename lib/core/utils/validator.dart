class Validator {
  static String? validateEmail(String? val) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (val == null) {
      return 'this field is required';
    } else if (val.trim().isEmpty) {
      return 'this field is required';
    } else if (emailRegex.hasMatch(val) == false) {
      return 'enter valid email';
    } else {
      return null;
    }
  }

  // static String? validatePassword(String? val) {
  //   if (val == null) {
  //     return 'this field is required';
  //   } else if (val.isEmpty) {
  //     return 'this field is required';
  //   } else if (val.length < 8) {
  //     return 'strong password please';
  //   } else {
  //     return null;
  //   }
  // }

  static String? validateConfirmPassword(String? val, String? password) {
    if (val == null || val.isEmpty) {
      return 'this field is required';
    } else if (val != password) {
      return 'same password';
    } else {
      return null;
    }
  }

  static String? validateUsername(String? val) {
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9,.-]+$');
    if (val == null) {
      return 'this field is required';
    } else if (val.isEmpty) {
      return 'this field is required';
    } else if (!usernameRegex.hasMatch(val)) {
      return 'enter valid username';
    } else {
      return null;
    }
  }

  static String? validateFullName(String? val) {
    if (val == null || val.isEmpty) {
      return 'this field is required';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? val) {
    if (val == null) {
      return 'this field is required';
    } else if (int.tryParse(val.trim()) == null) {
      return 'enter numbers only';
    } else if (val.trim().length != 11) {
      return 'enter value must equal 11 digit';
    } else {
      return null;
    }
  }

  static String? validateLoginPassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    } else if (val.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateLoginPhone(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (val.replaceAll(RegExp(r'\D'), '').length < 10) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? validatePhoneNumberField(String? val) {
    if (val == null || val.trim().isEmpty) return "Phone number is required";
    if (val.trim().length < 10) return "Invalid mobile number";
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
