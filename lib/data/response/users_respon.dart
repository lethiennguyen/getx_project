class LoginResponse {
  final bool success;
  final String message;
  final String token;

  const LoginResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      token: json['data']['token'] as String,
    );
  }
  @override
  String toString() {
    return 'LoginResponse(success: $success, message: $message, token: $token)';
  }
}
