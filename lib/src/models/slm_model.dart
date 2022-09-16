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
    });

    final String enPassKind;
    final String lowOxNumber;
    final String dtcDate;
    final String userId;
    final String lowOxTime;
    final String lowestOx;
    final String averageOx;
    final String totalTime;

    factory SlmModel.fromRawJson(String str) => SlmModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SlmModel.fromJson(Map<String, dynamic> json) => SlmModel(
        enPassKind: json["enPassKind"],
        lowOxNumber: json["lowOxNumber"],
        dtcDate: json["dtcDate"],
        userId: json["userID"],
        lowOxTime: json["lowOxTime"],
        lowestOx: json["lowestOx"],
        averageOx: json["averageOx"],
        totalTime: json["totalTime"],
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
    };
}
