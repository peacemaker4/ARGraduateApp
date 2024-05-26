class Group {
  String? id;
  String? group_name;
  String? institution;
  
  Group({
    this.id,
    this.group_name,
    this.institution,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      group_name: json['group_name'],
      institution: json['institution'],
    );
  }

}