// To parse this JSON data, do
//
//     final dlcModel = dlcModelFromJson(jsonString);

import 'dart:convert';

class DlcModel {
    DlcModel({
        required this.hrResult,
        required this.userId,
        required this.haveVoice,
        required this.dtcDate,
        required this.spo2Value,
        required this.bpValue,
        required this.hrValue,
        required this.pIndex,
        required this.spo2Result,
        required this.bpFlag,
        this.id,
        this.upload
    });

    final int? id;
    final String dtcDate;
    final double pIndex;
    final int haveVoice;
    final int bpFlag;
    final int bpValue;
    final int hrValue;
    final int hrResult;
    final int spo2Result;
    final int spo2Value;
    final int userId;
    final int? upload;

    factory DlcModel.fromRawJson(String str) => DlcModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DlcModel.fromJson(Map<String, dynamic> json) => DlcModel(
        hrResult: json["hrResult"],
        userId: json["userId"],
        haveVoice: json["haveVoice"],
        dtcDate: json["dtcDate"],
        spo2Value: json["spo2Value"],
        bpValue: json["bpValue"],
        hrValue: json["hrValue"],
        pIndex: json["pIndex"].toDouble(),
        spo2Result: json["spo2Result"],
        bpFlag: json["bpFlag"],
        id: json["id"],
        upload: json["upload"] ?? 0
    );

    Map<String, dynamic> toJson() => {
        "hrResult": hrResult,
        "userID": userId,
        "haveVoice": haveVoice,
        "dtcDate": dtcDate,
        "spo2Value": spo2Value,
        "bpValue": bpValue,
        "hrValue": hrValue,
        "pIndex": pIndex,
        "spo2Result": spo2Result,
        "bpFlag": bpFlag,
        "id": id,
        "upload": upload ?? 0 
    };
}
