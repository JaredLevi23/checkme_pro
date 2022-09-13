// To parse this JSON data, do
//
//     final smlModel = smlModelFromJson(jsonString);

import 'dart:convert';

class SmlModel {
    SmlModel({
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

    factory SmlModel.fromRawJson(String str) => SmlModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SmlModel.fromJson(Map<String, dynamic> json) => SmlModel(
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
