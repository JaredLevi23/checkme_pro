import 'dart:convert';

import 'dart:typed_data';

class EcgDetailsModel {
    EcgDetailsModel({
        required this.pvcsValue,
        required this.enFilterKind,
        required this.enLeadKind,
        required this.timeLength,
        required this.qtcValue,
        required this.stValue,
        this.arrEcgHeartRate,
        required this.qtValue,
        required this.isQt,
        this.arrEcgContent,
        required this.qrsValue,
        required this.type,
        required this.ecgResult,
        required this.hrValue,
        this.arrEcgContentUint,
        this.arrEcgHearRateUint
    });

    int enFilterKind;
    int enLeadKind;
    int hrValue;
    int pvcsValue;
    int qrsValue;
    int qtcValue;
    int qtValue;
    int stValue;
    int timeLength;
    String ecgResult;
    String type;
    bool isQt;
    List<int>? arrEcgHeartRate;
    List<double>? arrEcgContent;
    Uint8List? arrEcgHearRateUint;
    Uint8List? arrEcgContentUint;

    factory EcgDetailsModel.fromRawJson(String str) => EcgDetailsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EcgDetailsModel.fromJson(Map<String, dynamic> json) => EcgDetailsModel(
        pvcsValue: json["pvcsValue"],
        enFilterKind: json["enFilterKind"],
        enLeadKind: json["enLeadKind"],
        timeLength: json["timeLength"],
        qtcValue: json["qtcValue"],
        stValue: json["stValue"],
        arrEcgHeartRate: List<int>.from(json["arrEcgHeartRate"].map((x) => x)),
        qtValue: json["qtValue"],
        isQt: json["isQT"],
        arrEcgContent: List<double>.from(json["arrEcgContent"].map((x) => x.toDouble())),
        qrsValue: json["qrsValue"],
        type: json["type"],
        ecgResult: json["ecgResult"],
        hrValue: json["hrValue"],
        arrEcgContentUint: json["arrEcgContentUint"],
        arrEcgHearRateUint: json["arrEcgHearRateUint"],
    );

    Map<String, dynamic> toJson() => {
        "pvcsValue": pvcsValue,
        "enFilterKind": enFilterKind,
        "enLeadKind": enLeadKind,
        "timeLength": timeLength,
        "qtcValue": qtcValue,
        "stValue": stValue,
        "arrEcgHeartRate": arrEcgHeartRate != null ? List<dynamic>.from(arrEcgHeartRate!.map((x) => x)) : [] ,
        "qtValue": qtValue,
        "isQT": isQt,
        "arrEcgContent": arrEcgContent != null ? List<dynamic>.from(arrEcgContent!.map((x) => x)) : [],
        "qrsValue": qrsValue,
        "type": type,
        "ecgResult": ecgResult,
        "hrValue": hrValue,
        "arrEcgContentUint": arrEcgContentUint ?? [],
        "arrEcgHearRateUint": arrEcgHearRateUint ?? [],
    };
}
