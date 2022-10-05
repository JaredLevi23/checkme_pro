import 'dart:convert';

class PedModel {
    PedModel({
        required this.speed,
        required this.dctDate,
        required this.type,
        required this.userId,
        required this.totalTime,
        required this.calorie,
        required this.distance,
        required this.steps,
        required this.fat,
    });

    String type;
    double calorie;
    double distance;
    String dctDate;
    double fat;
    double speed;
    int steps;
    int totalTime;
    String userId;

    factory PedModel.fromRawJson(String str) => PedModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PedModel.fromJson(Map<String, dynamic> json) => PedModel(
        speed: json["speed"].toDouble(),
        dctDate: json["dtcDate"],
        type: json["type"],
        userId: json["userID"],
        totalTime: json["totalTime"],
        calorie: json["calorie"].toDouble(),
        distance: json["distance"].toDouble(),
        steps: json["steps"],
        fat: json["fat"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "speed": speed,
        "dctDate": dctDate,
        "type": type,
        "userID": userId,
        "totalTime": totalTime,
        "calorie": calorie,
        "distance": distance,
        "steps": steps,
        "fat": fat,
    };
}
