class Validators {
  static String? validateName(String name) {
    if (name.isEmpty) {
      return "Name cannot be empty!";
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email cannot be empty!";
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,4}$').hasMatch(email)) {
      return "Enter a valid email address!";
    }
    return null;
  }

  static String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return "Phone number cannot be empty!";
    }
    if (phone.length != 10) {
      return "Enter a valid 10-digit phone number!";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password cannot be empty!";
    }
    return null;
  }
}
