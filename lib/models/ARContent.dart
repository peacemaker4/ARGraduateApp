class ARContent {
  String? uid;
  String? type;
  String? image_url;
  String? file_url;
  String? image_name;
  String? file_name;
  String? texture_url;
  
  ARContent({
    this.uid,
    this.type,
    this.image_url,
    this.file_url,
    this.image_name,
    this.file_name,
    this.texture_url,
  });

  factory ARContent.fromJson(Map<String, dynamic> json) {
    return ARContent(
      uid: json['uid'],
      type: json['type'],
      image_url: json['img_url'],
      file_url: json['file_url'],
      image_name: json['img_name'],
      file_name: json['file_name'],
      texture_url: json['texture_url'],
    );
  }

}