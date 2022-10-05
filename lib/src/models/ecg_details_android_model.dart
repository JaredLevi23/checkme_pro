// To parse this JSON data, do
//
//     final ecgDetailsAndroidModel = ecgDetailsAndroidModelFromJson(jsonString);

import 'dart:convert';

class EcgDetailsAndroidModel {
    EcgDetailsAndroidModel({
        required this.type,
        required this.bytes,
        required this.hr,
        required this.hrList,
        required this.hrSize,
        required this.pvcs,
        required this.qrs,
        required this.qt,
        required this.qtc,
        required this.st,
        required this.total,
        required this.waveList,
        required this.waveSize,
        required this.waveViewList,
    });

    String type;
    String bytes;
    int hr;
    String hrList;
    int hrSize;
    int pvcs;
    int qrs;
    int qt;
    int qtc;
    int st;
    int total;
    String waveList;
    int waveSize;
    List waveViewList;

    factory EcgDetailsAndroidModel.fromRawJson(String str) => EcgDetailsAndroidModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EcgDetailsAndroidModel.fromJson(Map<String, dynamic> json) => EcgDetailsAndroidModel(
        type: json["type"],
        bytes: json["bytes"],
        hr: json["hr"],
        hrList: json["hrList"],
        hrSize: json["hrSize"],
        pvcs: json["pvcs"],
        qrs: json["qrs"],
        qt: json["qt"],
        qtc: json["qtc"],
        st: json["st"],
        total: json["total"],
        waveList: json["waveList"],
        waveSize: json["waveSize"],
        waveViewList: jsonDecode(json["waveViewList"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "bytes": bytes,
        "hr": hr,
        "hrList": hrList,
        "hrSize": hrSize,
        "pvcs": pvcs,
        "qrs": qrs,
        "qt": qt,
        "qtc": qtc,
        "st": st,
        "total": total,
        "waveList": waveList,
        "waveSize": waveSize,
        "waveViewList": waveViewList,
    };
}
