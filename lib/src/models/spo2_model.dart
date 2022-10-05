// To parse this JSON data, do
//
//     final spo2Model = spo2ModelFromJson(jsonString);

import 'dart:convert';

class Spo2Model {
    Spo2Model({
        required this.prValue,
        required this.spo2Value,
        required this.enPassKind,
        required this.pIndex,
        required this.dtcDate,
        required this.userId,
        required this.type
    });

    final String dtcDate;
    final String userId;
    final String type;
    final int spo2Value;
    final int enPassKind;
    final int prValue;
    final dynamic pIndex;

    factory Spo2Model.fromRawJson(String str) => Spo2Model.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Spo2Model.fromJson(Map<String, dynamic> json) => Spo2Model(
        prValue: json["prValue"],
        spo2Value: json["spo2Value"],
        enPassKind: json["enPassKind"],
        pIndex: json["pIndex"],
        dtcDate: json["dtcDate"],
        userId: json["userID"],
        type: json["type"]
    );

    Map<String, dynamic> toJson() => {
        "prValue": prValue,
        "spo2Value": spo2Value,
        "enPassKind": enPassKind,
        "pIndex": pIndex,
        "dtcDate": dtcDate,
        "userID": userId,
        "type": type
    };
}
