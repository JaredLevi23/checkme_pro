// To parse this JSON data, do
//
//     final ecgModel = ecgModelFromJson(jsonString);

import 'dart:convert';

class EcgModel {
    EcgModel({
        required this.enLeadKind,
        required this.enPassKind,
        required this.dtcDate,
        required this.userId,
        required this.haveVoice,
        this.id,
        this.inServer
    });

    final int? id;
    final String dtcDate;
    final int? userId;
    final int haveVoice;
    final int enLeadKind;
    final int enPassKind;
    final int? inServer;

    factory EcgModel.fromRawJson(String str) => EcgModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EcgModel.fromJson(Map<String, dynamic> json) => EcgModel(
        id        : json["id"],
        enPassKind: json["enPassKind"],
        dtcDate   : json["dtcDate"],
        userId    : json["userId"],
        haveVoice : json["haveVoice"],
        enLeadKind: json["enLeadKind"],
        inServer  : json["inServer"] ?? 0
    );

    Map<String, dynamic> toJson() => {
        "id"        : id,
        "enLeadKind": enLeadKind,
        "enPassKind": enPassKind,
        "dtcDate"   : dtcDate,
        "userID"    : userId,
        "haveVoice" : haveVoice,
        "inServer"  : inServer ?? 0
    };
}
