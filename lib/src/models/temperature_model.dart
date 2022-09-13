import 'dart:convert';

class TemperatureModel {
    TemperatureModel({
        required this.userId,
        required this.dtcDate,
        required this.tempValue,
        required this.measureMode,
        required this.enPassKind,
    });

    String userId;
    String dtcDate;
    String tempValue;
    String measureMode;
    String enPassKind;

    factory TemperatureModel.fromRawJson(String str) => TemperatureModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TemperatureModel.fromJson(Map<String, dynamic> json) => TemperatureModel(
        userId: json["userID"],
        dtcDate: json["dtcDate"],
        tempValue: json["tempValue"],
        measureMode: json["measureMode"],
        enPassKind: json["enPassKind"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "dtcDate": dtcDate,
        "tempValue": tempValue,
        "measureMode": measureMode,
        "enPassKind": enPassKind,
    };
}
