class User {
  final String id;
  final String firebaseUid;
  final String email;
  final String role;

  User({required this.id, required this.firebaseUid, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firebaseUid: json['firebaseUid'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'farmer',
    );
  }
}