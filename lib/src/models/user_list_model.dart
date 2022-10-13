import 'dart:convert';
import 'dart:io';
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

    factory UserListModel.fromJson(Map<String, dynamic> jsonMap) => UserListModel(
        type: jsonMap["type"],
        userList: Platform.isIOS ?
        List<UserModel>.from(jsonMap["userList"].map((x) => UserModel.fromJson(x)))
        : List<UserModel>.from( json.decode( jsonMap["userList"] ).map( (x) => UserModel.fromJson( x ) ) ),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "userList": List<dynamic>.from(userList.map((x) => x.toJson())),
    };
}