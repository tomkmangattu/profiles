// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

UserData userListFromJson(String str) => UserData.fromJson(json.decode(str));

String userListToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.userList,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<User> userList;
  List<String> likedProfiles = [];
  final int total;
  final int page;
  final int limit;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userList: List<User>.from(json["data"].map((x) => User.fromJson(x))),
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(userList.map((x) => x.toJson())),
        "total": total,
        "page": page,
        "limit": limit,
      };
}

class User {
  User({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
  });

  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        title: json["title"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "firstName": firstName,
        "lastName": lastName,
        "picture": picture,
      };
}
