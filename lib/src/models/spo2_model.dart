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
        this.id,
        this.upload
    });

    final int? id;
    final String dtcDate;
    final int userId;
    final int spo2Value;
    final int prValue;
    final int enPassKind;
    final dynamic pIndex;
    final int? upload;

    factory Spo2Model.fromRawJson(String str) => Spo2Model.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Spo2Model.fromJson(Map<String, dynamic> json) => Spo2Model(
        prValue: json["prValue"],
        spo2Value: json["spo2Value"],
        enPassKind: json["enPassKind"],
        pIndex: json["pIndex"],
        dtcDate: json["dtcDate"],
        userId: json["userId"],
        id: json["id"],
        upload: json["upload"]
    );

    Map<String, dynamic> toJson() => {
        "prValue": prValue,
        "spo2Value": spo2Value,
        "enPassKind": enPassKind,
        "pIndex": pIndex,
        "dtcDate": dtcDate,
        "userID": userId,
        "id": id,
        "upload": upload ?? 0
    };
}
