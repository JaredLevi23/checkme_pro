import 'dart:convert';

class PedModel {
    PedModel({
        required this.speed,
        required this.dtcDate,
        required this.userId,
        required this.totalTime,
        required this.calorie,
        required this.distance,
        required this.steps,
        required this.fat,
        this.id,
        this.upload
    });

    final int? id;
    final String dtcDate;
    final double calorie;
    final double distance;
    final double fat;
    final double speed;
    final int steps;
    final int totalTime;
    final int userId;
    final int? upload;

    factory PedModel.fromRawJson(String str) => PedModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PedModel.fromJson(Map<String, dynamic> json) => PedModel(
        speed: json["speed"].toDouble(),
        dtcDate: json["dtcDate"],
        id: json["id"],
        userId: json["userId"],
        totalTime: json["totalTime"],
        calorie: json["calorie"].toDouble(),
        distance: json["distance"].toDouble(),
        steps: json["steps"],
        fat: json["fat"].toDouble(),
        upload: json["upload"]
    );

    Map<String, dynamic> toJson() => {
        "speed": speed,
        "dtcDate": dtcDate,
        "id": id,
        "userID": userId,
        "totalTime": totalTime,
        "calorie": calorie,
        "distance": distance,
        "steps": steps,
        "fat": fat,
        "upload": upload ?? 0
    };
}
