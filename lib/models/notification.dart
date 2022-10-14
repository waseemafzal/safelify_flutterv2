class Notification {
  Notification({
    required this.body,
    required this.resourceId,
    required this.resourceType,
    required this.createdDate,
    required this.readed,
  });

  String body;
  String resourceId;
  String resourceType;
  DateTime createdDate;
  String readed;

  static List<Notification> listFromMap(List<dynamic> json) {
    return List<Notification>.from(
      json.map(
        (x) => Notification.fromMap(x),
      ),
    );
  }

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
        body: json["body"],
        resourceId: json["resource_id"],
        resourceType: json["resource_type"],
        createdDate: DateTime.parse(json["created_date"]),
        readed: json["readed"],
      );

  Map<String, dynamic> toMap() => {
        "body": body,
        "resource_id": resourceId,
        "resource_type": resourceType,
        "created_date": createdDate.toIso8601String(),
        "readed": readed,
      };
}
