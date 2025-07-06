class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String mobile;
  final String phoneCode;

  UserModel(
      {required this.firstName,
        required this.lastName,
        required this.email,
        required this.phone,
        required this.mobile,
        required this.phoneCode});

  // Convert JSON to User object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        firstName: json["first_name"] ?? "N/A",
        lastName: json["last_name"] ?? "N/A",
        email: json["email"] ?? "N/A",
        phone: json["phone"] ?? "N/A",
        mobile: json["mobile"] ?? "N/A",
        phoneCode: json["phonecode"] ?? "+91");
  }
}
