// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

class UserModel {
    UserModel({
        required this.height,
        required this.iconID,
        required this.birthDay,
        required this.userId,
        required this.gender,
        required this.weight,
        required this.age,
        required this.userName,
        this.id,
        this.inServer
    });

    final int? id;
    final int userId;
    final String userName;
    final String birthDay;
    final String gender;
    final String weight;
    final String height;
    final String age;
    final String iconID;
    final int? inServer;

    factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId:   json["userId"],
        gender:   json["gender"],
        birthDay: json["birthDay"],
        height:   json["height"],
        iconID:   json["iconID"],
        userName: json["userName"],
        weight:   json["weight"],
        age:      json["age"],
        inServer: json["inServer"] ?? 0,
        id:       json["id"]
    );

    Map<String, dynamic> toJson() => {
        "height"  : height,
        "iconID"  : iconID,
        "birthDay": birthDay,
        "userID"  : userId,
        "gender"  : gender,
        "weight"  : weight,
        "age"     : age,
        "userName": userName,
        "inServer": inServer,
        "id"      : id
    };
}
