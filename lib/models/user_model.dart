/// Minimal user profile model.
class UserModel {
  const UserModel({
    required this.fullName,
    required this.email,
    this.phone = "",
  });

  final String fullName;
  final String email;
  final String phone;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "full_name": fullName,
    "email": email,
    "phone": phone,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    fullName: (json["full_name"] ?? "") as String,
    email: (json["email"] ?? "") as String,
    phone: (json["phone"] ?? "") as String,
  );
}
