import 'dart:convert';

class TemperatureModel {
    TemperatureModel({
        required this.userId,
        required this.dtcDate,
        required this.tempValue,
        required this.measureMode,
        required this.enPassKind,
        required this.type
    });

    String type;
    String userId;
    String dtcDate;
    double tempValue;
    int measureMode;
    int enPassKind;

    factory TemperatureModel.fromRawJson(String str) => TemperatureModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TemperatureModel.fromJson(Map<String, dynamic> json) => TemperatureModel(
        userId: json["userID"],
        dtcDate: json["dtcDate"],
        tempValue: double.parse( json["tempValue"].toString() ) ,
        measureMode: json["measureMode"],
        enPassKind: json["enPassKind"],
        type: json["type"]
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "dtcDate": dtcDate,
        "tempValue": tempValue,
        "measureMode": measureMode,
        "enPassKind": enPassKind,
        "type": type
    };
}
