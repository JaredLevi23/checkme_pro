// To parse this JSON data, do
//
//     final ecgModel = ecgModelFromJson(jsonString);

import 'dart:convert';

class EcgModel {
    EcgModel({
        required this.type,
        required this.enLeadKind,
        required this.enPassKind,
        required this.dtcDate,
        required this.userId,
        required this.haveVoice,
        this.isSync
    });

    final String type;
    final String enLeadKind;
    final String enPassKind;
    final String dtcDate;
    final String userId;
    final String haveVoice;
    bool? isSync;

    factory EcgModel.fromRawJson(String str) => EcgModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EcgModel.fromJson(Map<String, dynamic> json) => EcgModel(
        type: json["type"],
        enLeadKind: json["enLeadKind"],
        enPassKind: json["enPassKind"],
        dtcDate: json["dtcDate"],
        userId: json["userID"],
        haveVoice: json["haveVoice"],
        isSync: false
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "enLeadKind": enLeadKind,
        "enPassKind": enPassKind,
        "dtcDate": dtcDate,
        "userID": userId,
        "haveVoice": haveVoice,
    };
}
