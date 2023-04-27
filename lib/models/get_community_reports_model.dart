class CommunityReport {
  CommunityReport({
    this.id,
    this.title,
    this.file = '',
    this.createdOn,
    this.userId,
    this.name,
    this.image,
    this.commentCount,
    required this.city,
  });

  String? id;
  String? title;
  String file;
  String? createdOn;
  String? userId;
  String? name;
  String? image;
  int? commentCount;
  String city;

  static List<CommunityReport> listFromMap(List<dynamic> json) {
    return List<CommunityReport>.from(
      json.map(
        (x) => CommunityReport.fromJson(x),
      ),
    );
  }

  factory CommunityReport.fromJson(Map<String, dynamic> json) => CommunityReport(
        id: json["id"],
        title: json["title"],
        file: json["file"] == null ? '' : json["file"],
        createdOn: json["created_on"],
        userId: json["user_id"],
        name: json["name"],
        image: json["image"],
        commentCount: json["commentCount"],
        city: json['city'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "file": file == null ? null : file,
        "created_on": createdOn,
        "user_id": userId,
        "name": name,
        "image": image,
        "commentCount": commentCount,
      };
}
