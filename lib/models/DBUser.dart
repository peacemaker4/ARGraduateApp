class DBUser {
  String? uid;
  String? email;
  String? username;
  String? role;
  String? img_url;
  
  DBUser({
    this.uid,
    this.email,
    this.username,
    this.role,
    this.img_url,
  });

  factory DBUser.fromJson(Map<String, dynamic> json) {
    return DBUser(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
      img_url: json['img_url'],
    );
  }
}