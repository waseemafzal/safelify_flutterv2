class ReportCategory {
  ReportCategory({
    required this.id,
    required this.category,
  });

  String id;
  String category;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportCategory && other.id == id;
  }

  static List<ReportCategory> listFromMap(List<dynamic> json) {
    return List<ReportCategory>.from(
      json.map(
        (x) => ReportCategory.fromMap(x),
      ),
    );
  }

  factory ReportCategory.fromMap(Map<String, dynamic> json) => ReportCategory(
        id: json["id"],
        category: json["category"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
      };
}
