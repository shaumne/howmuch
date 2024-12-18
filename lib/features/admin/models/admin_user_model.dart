class AdminUser {
  final String uid;
  final String email;
  final bool isAdmin;
  
  AdminUser({
    required this.uid,
    required this.email,
    this.isAdmin = false,
  });
  
  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      uid: json['uid'],
      email: json['email'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
} 