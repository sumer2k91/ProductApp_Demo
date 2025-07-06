class LoginModel {
  final String message;
  final String access_token;
  final String token_type;
  final String expires_at;
  // final User user;

  LoginModel({
    required this.message,
    required this.access_token,
    required this.token_type,
    required this.expires_at,
    // required this.user,
  });

  // Convert JSON to User object
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json["message"],
      access_token: json["access_token"],
      token_type: json["token_type"],
      expires_at: json["expires_at"],
    );
  }
}