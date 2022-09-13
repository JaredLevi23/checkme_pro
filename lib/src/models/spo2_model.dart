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
        required this.dctDate,
        required this.userId,
    });

    final String prValue;
    final String spo2Value;
    final String enPassKind;
    final String pIndex;
    final String dctDate;
    final String userId;

    factory Spo2Model.fromRawJson(String str) => Spo2Model.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Spo2Model.fromJson(Map<String, dynamic> json) => Spo2Model(
        prValue: json["prValue"],
        spo2Value: json["spo2Value"],
        enPassKind: json["enPassKind"],
        pIndex: json["pIndex"],
        dctDate: json["dctDate"],
        userId: json["userID"],
    );

    Map<String, dynamic> toJson() => {
        "prValue": prValue,
        "spo2Value": spo2Value,
        "enPassKind": enPassKind,
        "pIndex": pIndex,
        "dctDate": dctDate,
        "userID": userId,
    };
}
