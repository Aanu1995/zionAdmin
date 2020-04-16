class Validators {
  static String Function(String) validateName([String error]) {
    return (String value) {
      if (value.isEmpty) {
        return error ?? 'Name is required.';
      }
      final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
      if (!nameExp.hasMatch(value)) {
        return error ?? 'Please enter only alphabetical characters.';
      }
      return null;
    };
  }

  static String Function(String) validateAddress([String error]) {
    return (String value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return error ?? 'Address is required.';
      }
      if (value.length < 8) {
        return error ?? 'Address should be greater than 2 word';
      }
      return null;
    };
  }

  static validateAddress2(String value, [String error]) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return error ?? 'Address is required.';
    }
    if (value.length < 8) {
      return error ?? 'Address should be greater than 2 word';
    }
    return null;
  }

  static String Function(String) validatePhone([String error]) {
    return (String value) {
      if (value.isEmpty) {
        return error ?? 'Phone number is required.';
      }
      if (!RegExp(r'^\d+?$').hasMatch(value) ||
          !value.startsWith(RegExp("0[1789]")) ||
          // Land lines eg 01
          (value.startsWith("01") && value.length != 9) ||
          // Land lines eg 080
          (value.startsWith(RegExp("0[789]")) && value.length != 11)) {
        return error ?? 'Not a valid phone number.';
      }
      return null;
    };
  }

  static validatePhone2(String value, [String error]) {
    if (value.isEmpty) {
      return error ?? 'Phone number is required.';
    }
    if (!RegExp(r'^\d+?$').hasMatch(value) ||
        !value.startsWith(RegExp("0[1789]")) ||
        // Land lines eg 01
        (value.startsWith("01") && value.length != 9) ||
        // Land lines eg 080
        (value.startsWith(RegExp("0[789]")) && value.length != 11)) {
      return error ?? 'Not a valid phone number.';
    }
    return null;
  }

  static String Function(String) validateEmail([String error]) {
    return (String value) {
      if (value.isEmpty) {
        return error ?? 'Email is required.';
      }
      final RegExp regExp = new RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regExp.hasMatch(value)) {
        return error ?? 'Not a valid email.';
      }
      return null;
    };
  }

  static String Function(String) validatePassword([String error]) {
    return (String value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return error ?? 'Password is required.';
      }
      return null;
    };
  }

  static String confirmPassword(String confirmPassword, String password,
      [String error]) {
    if (confirmPassword.isEmpty) {
      return error ?? 'Password is required.';
    }
    if (confirmPassword != password) {
      return error ?? 'Passwords do not match';
    }
    return null;
  }
}
