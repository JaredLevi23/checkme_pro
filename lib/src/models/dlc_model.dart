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
        required this.type,
    });

    int hrResult;
    String userId;
    int spo2Result;
    int spo2Value;
    int bpValue;
    int hrValue;
    int bpFlag;
    bool haveVoice;
    double pIndex;
    String dtcDate;
    String type;

    factory DlcModel.fromRawJson(String str) => DlcModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DlcModel.fromJson(Map<String, dynamic> json) => DlcModel(
        hrResult: json["hrResult"],
        userId: json["userID"],
        haveVoice: json["haveVoice"],
        dtcDate: json["dtcDate"],
        spo2Value: json["spo2Value"],
        bpValue: json["bpValue"],
        hrValue: json["hrValue"],
        pIndex: json["pIndex"].toDouble(),
        spo2Result: json["spo2Result"],
        bpFlag: json["bpFlag"],
        type: json["type"],
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
        "type": type,
    };
}
