class Chat {
  Chat({
    required this.conversationId,
    required this.userId,
    required this.userImage,
    required this.userName,
    required this.isOwner,
    required this.messages,
  });

  String conversationId;
  String userId;
  String userImage;
  String userName;
  bool isOwner;
  List<Message> messages;

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
        conversationId: json["conversation_id"],
        userId: json["user_id"],
        userImage: json["user_image"],
        userName: json["user_name"],
        isOwner: json["is_owner"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "conversation_id": conversationId,
        "user_id": userId,
        "user_image": userImage,
        "user_name": userName,
        "is_owner": isOwner,
        "messages": List<dynamic>.from(messages.map((x) => x.toMap())),
      };
}

class Message {
  Message({
    required this.body,
    required this.conversationId,
    required this.name,
    required this.messageId,
    required this.userId,
    required this.image,
    required this.date,
    required this.read,
    required this.isOwner,
    required this.status,
    required this.deletedBy,
  });

  String body;
  String conversationId;
  String name;
  String messageId;
  String userId;
  String image;
  String date;
  int read;
  bool isOwner;
  int status;
  int deletedBy;

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        body: json["body"],
        conversationId: json["conversation_id"],
        name: json["name"],
        messageId: json["message_id"],
        userId: json["user_id"],
        image: json["image"],
        date: json["date"],
        read: json["read"],
        isOwner: json["is_owner"],
        status: json["status"],
        deletedBy: json["deleted_by"],
      );

  Map<String, dynamic> toMap() => {
        "body": body,
        "conversation_id": conversationId,
        "name": name,
        "message_id": messageId,
        "user_id": userId,
        "image": image,
        "date": date,
        "read": read,
        "is_owner": isOwner,
        "status": status,
        "deleted_by": deletedBy,
      };
}
