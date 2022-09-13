// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

class UserModel {
    UserModel({
        required this.height,
        required this.iconId,
        required this.birthday,
        required this.type,
        required this.userId,
        required this.gender,
        required this.weight,
        required this.age,
        required this.userName,
    });

    final String height;
    final String iconId;
    final String birthday;
    final String type;
    final String userId;
    final String gender;
    final String weight;
    final String age;
    final String userName;

    factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        height: json["height"],
        iconId: json["iconID"],
        birthday: json["birthday"],
        type: json["type"],
        userId: json["userID"],
        gender: json["gender"],
        weight: json["weight"],
        age: json["age"],
        userName: json["userName"],
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "iconID": iconId,
        "birthday": birthday,
        "type": type,
        "userID": userId,
        "gender": gender,
        "weight": weight,
        "age": age,
        "userName": userName,
    };
}
