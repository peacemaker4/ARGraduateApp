class DBUser {
  String? uid;
  String? email;
  String? username;
  String? role;
  
  DBUser({
    this.uid,
    this.email,
    this.username,
    this.role,
  });

  factory DBUser.fromJson(Map<String, dynamic> json) {
    return DBUser(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
    );
  }
}