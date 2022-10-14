import 'dart:convert';

import 'dart:io';

class EcgDetailsModel {
    EcgDetailsModel({
        required this.pvcsValue,
        required this.timeLength,
        required this.qtcValue,
        required this.stValue,
        this.arrHR,
        required this.qtValue,
        this.arrEcg,
        required this.qrsValue,
        required this.hrValue,
        required this.dtcDate,
        this.id,
        this.upload
    });

    //int enFilterKind;
    //int enLeadKind;
    //int isQt;
    //String ecgResult;
    int? id;
    String dtcDate;
    int hrValue;
    int stValue;
    int qrsValue;
    int qtValue;
    int qtcValue;
    int pvcsValue;
    int timeLength;
    List? arrEcg;
    List? arrHR;
    int? upload;
    

    factory EcgDetailsModel.fromRawJson(String str) => EcgDetailsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EcgDetailsModel.fromJson(Map<String, dynamic> jsonMap) => EcgDetailsModel(
        pvcsValue: jsonMap["pvcsValue"],
        timeLength: jsonMap["timeLength"],
        qtcValue: jsonMap["qtcValue"],
        stValue: jsonMap["stValue"],
        arrHR: Platform.isIOS 
          ?List<int>.from(jsonMap["arrHR"].map((x) => x.toInt() ))
          : List<int>.from(json.decode( jsonMap["arrHR"] ).map((x) => x.toInt() )),
        arrEcg: Platform.isIOS
          ? List<double>.from(jsonMap["arrEcg"].map((x) => x.toDouble()))
          : List<double>.from(json.decode(jsonMap["arrEcg"]).map((x) => x.toDouble())),
        qtValue: jsonMap["qtValue"],
        qrsValue: jsonMap["qrsValue"],
        hrValue: jsonMap["hrValue"],
        dtcDate: jsonMap["dtcDate"],
        upload  : jsonMap["upload"] ?? 0
    );

    factory EcgDetailsModel.fromJsonDB(Map<String, dynamic> jsonMap) => EcgDetailsModel(
        pvcsValue: jsonMap["pvcsValue"],
        timeLength: jsonMap["timeLength"],
        qtcValue: jsonMap["qtcValue"],
        stValue: jsonMap["stValue"],
        arrHR: List<int>.from(json.decode( jsonMap["arrHR"] ).map((x) => x.toInt() )),
        arrEcg: List<double>.from(json.decode(jsonMap["arrEcg"]).map((x) => x.toDouble())),
        qtValue: jsonMap["qtValue"],
        qrsValue: jsonMap["qrsValue"],
        hrValue: jsonMap["hrValue"],
        dtcDate: jsonMap["dtcDate"],
        upload  : jsonMap["upload"] ?? 0
    );

    Map<String, dynamic> toJson() => {
        "pvcsValue": pvcsValue,
        "timeLength": timeLength,
        "qtcValue": qtcValue,
        "stValue": stValue,
        "arrHR": arrHR != null ? List<dynamic>.from(arrHR!.map((x) => x)).toString() : [].toString() ,
        "qtValue": qtValue,
        "arrEcg": arrEcg != null ? List<dynamic>.from(arrEcg!.map((x) => x)).toString() : [].toString(),
        "qrsValue": qrsValue,
        "hrValue": hrValue,
        "dtcDate": dtcDate,
        "upload": upload ?? 0
    };
}
