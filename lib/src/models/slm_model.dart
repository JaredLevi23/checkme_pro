// To parse this JSON data, do
//
//     final slmModel = slmModelFromJson(jsonString);

import 'dart:convert';

class SlmModel {
    SlmModel({
        required this.enPassKind,
        required this.lowOxNumber,
        required this.dtcDate,
        required this.userId,
        required this.lowOxTime,
        required this.lowestOx,
        required this.averageOx,
        required this.totalTime,
        this.id,
        this.inServer
    });

    final int? id;
    final int enPassKind;
    final int lowOxNumber;
    final String dtcDate;
    final int userId;
    final int lowOxTime;
    final int lowestOx;
    final int averageOx;
    final int totalTime;
    final int? inServer;

    factory SlmModel.fromRawJson(String str) => SlmModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SlmModel.fromJson(Map<String, dynamic> json) => SlmModel(
        enPassKind: json["enPassKind"],
        lowOxNumber: json["lowOxNumber"],
        dtcDate: json["dtcDate"],
        userId: json["userId"],
        lowOxTime: json["lowOxTime"],
        lowestOx: json["lowestOx"],
        averageOx: json["averageOx"],
        totalTime: json["totalTime"],
        id: json["id"],
        inServer: json["inServer"]
    );

    Map<String, dynamic> toJson() => {
        "enPassKind": enPassKind,
        "lowOxNumber": lowOxNumber,
        "dtcDate": dtcDate,
        "userID": userId,
        "lowOxTime": lowOxTime,
        "lowestOx": lowestOx,
        "averageOx": averageOx,
        "totalTime": totalTime,
        "id": id,
        "inServer": inServer ?? 0
    };
}
