class User {
  User({
    required this.userId,
    required this.username,
    required this.name,
    required this.email,
    required this.mobile,
    required this.profilePic,
    required this.referalCode,
    required this.accessToken,
    required this.password,
    required this.shareMessage,
    required this.cities,
    required this.sms_to,
  });

  String userId;
  String username;
  String name;
  String email;
  String mobile;
  String profilePic;
  String referalCode;
  String accessToken;
  String password;
  String shareMessage;
  String sms_to;
  List<String> cities;

  factory User.fromMap(Map<String, dynamic> json) => User(
        userId: json['user']["user_id"],
        username: json['user']["username"],
        name: json['user']["name"],
        email: json['user']["email"],
        mobile: json['user']["mobile"],
        profilePic: json['user']["profilePic"],
        referalCode: json['user']["referal_code"],
        accessToken: json['user']["access_token"],
        password: json['user']['password'] ?? '',
        shareMessage: json['share_message'],
        cities: [for (var val in json['cities']) "${val['city']}"],
        sms_to: json['sms_to'],
      );

  Map<String, dynamic> toMap() => {
        'user': {
          "user_id": userId,
          "username": username,
          "name": name,
          "email": email,
          "mobile": mobile,
          "profilePic": profilePic,
          "referal_code": referalCode,
          "access_token": accessToken,
          "password": password,
        },
        'share_message': shareMessage,
        'sms_to': sms_to,
        'cities': [
          for (var val in cities) {'city': val}
        ]
      };
}
