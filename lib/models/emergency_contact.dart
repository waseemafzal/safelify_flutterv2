class EmergencyContact {
  EmergencyContact({
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
    required this.email,
    required this.type,
    this.image,
  });

  String id;
  String name;
  String contact;
  String email;
  String address;
  String type;
  String? image;

  static List<EmergencyContact> listFromMap(List<dynamic> json) {
    return List<EmergencyContact>.from(
      json.map(
        (x) => EmergencyContact.fromMap(x),
      ),
    );
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> json) => EmergencyContact(
        id: json["id"],
        name: json["name"],
        contact: json["contact"],
        address: json['address'] ?? 'Not Provided',
        email: json['email'] ?? 'Not Provided',
        type: json['type'],
        image: json['image'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "contact": contact,
      };
}
