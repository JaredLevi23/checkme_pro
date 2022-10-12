import 'dart:convert';

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
        required this.dtcDate
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
    String dtcDate;
    int isQt;
    List<int>? arrEcgHeartRate;
    List<double>? arrEcgContent;
    

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
        dtcDate: json["dtcDate"]
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
        "dtcDate": dtcDate
    };
}
