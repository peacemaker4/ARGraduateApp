class DBUser {
  String? uid;
  String? email;
  String? username;
  String? role;
  String? img_url;
  String? group;
  
  DBUser({
    this.uid,
    this.email,
    this.username,
    this.role,
    this.img_url,
    this.group,
  });

  factory DBUser.fromJson(Map<String, dynamic> json) {
    return DBUser(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
      img_url: json['img_url'],
      group: json['group'],
    );
  }
}