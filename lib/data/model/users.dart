class User {
  final int tax_code;
  final String user_name;
  final String password;
  const User({
    required this.tax_code,
    required this.user_name,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {'tax_code': tax_code, 'user_name': user_name, 'password': password};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      tax_code: json['tax_code'],
      user_name: json['user_name'],
      password: json['password'],
    );
  }
}
