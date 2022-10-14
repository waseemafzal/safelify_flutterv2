class AdminContacts {
  List<City> cities;
  List<Contact> contacts;
  AdminContacts({
    required this.cities,
    required this.contacts,
  });

  factory AdminContacts.fromJson(Map<String, dynamic> json) {
    return AdminContacts(
      cities: City.listFromMap(
        json['cities'],
      ),
      contacts: Contact.listFromMap(json['data']),
    );
  }
}

class City {
  City({
    required this.cityId,
    required this.city,
  });

  String cityId;
  String city;

  static List<City> listFromMap(List<dynamic> json) {
    return List<City>.from(
      json.map(
        (x) => City.fromMap(x),
      ),
    );
  }

  factory City.fromMap(Map<String, dynamic> json) => City(
        cityId: json["city_id"],
        city: json["city"],
      );

  Map<String, dynamic> toMap() => {
        "city_id": cityId,
        "city": city,
      };
}

class Contact {
  Contact({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.address,
    required this.type,
    required this.image,
    required this.cityId,
    required this.city,
  });

  static List<Contact> listFromMap(List<dynamic> json) {
    return List<Contact>.from(
      json.map(
        (x) => Contact.fromMap(x),
      ),
    );
  }

  String id;
  String name;
  String contact;
  String email;
  String address;
  String type;
  String image;
  String cityId;
  String city;

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        contact: json["contact"],
        email: json["email"],
        address: json["address"],
        type: json["type"],
        image: json["image"],
        cityId: json["city_id"],
        city: json["city"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "contact": contact,
        "email": email,
        "address": address,
        "type": type,
        "image": image,
        "city_id": cityId,
        "city": city,
      };
}
