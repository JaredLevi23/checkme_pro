// To parse this JSON data, do
//
//     final ecgModelAndroid = ecgModelAndroidFromJson(jsonString);

import 'dart:convert';

class EcgModelAndroid {
    EcgModelAndroid({
        required this.type,
        required this.date,
        required this.face,
        required this.timeString,
        required this.userId,
        required this.voice,
        required this.way,
    });

    String type;
    String date;
    String face;
    String timeString;
    String userId;
    String voice;
    String way;

    factory EcgModelAndroid.fromRawJson(String str) => EcgModelAndroid.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EcgModelAndroid.fromJson(Map<String, dynamic> json) => EcgModelAndroid(
        type: json["type"],
        date: json["date"],
        face: json["face"],
        timeString: json["timeString"],
        userId: json["userID"],
        voice: json["voice"],
        way: json["way"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "date": date,
        "face": face,
        "timeString": timeString,
        "userID": userId,
        "voice": voice,
        "way": way,
    };
}
