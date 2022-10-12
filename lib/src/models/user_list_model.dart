import 'dart:convert';
import 'models.dart';

class UserListModel {
    UserListModel({
        required this.type,
        required this.userList,
    });

    final String type;
    final List<UserModel> userList;

    factory UserListModel.fromRawJson(String str) => UserListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserListModel.fromJson(Map<String, dynamic> json) => UserListModel(
        type: json["type"],
        userList: List<UserModel>.from(json["userList"].map((x) => UserModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "userList": List<dynamic>.from(userList.map((x) => x.toJson())),
    };
}