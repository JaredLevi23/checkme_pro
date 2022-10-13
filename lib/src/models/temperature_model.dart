import 'dart:convert';

class TemperatureModel {
    TemperatureModel({
        required this.userId,
        required this.dtcDate,
        required this.tempValue,
        required this.measureMode,
        required this.enPassKind,
        this.id,
        this.upload
    });

    final int? id;
    final String dtcDate;
    final int userId;
    final double tempValue;
    final int measureMode;
    final int enPassKind;
    final int? upload;

    factory TemperatureModel.fromRawJson(String str) => TemperatureModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TemperatureModel.fromJson(Map<String, dynamic> json) => TemperatureModel(
        userId: json["userId"],
        dtcDate: json["dtcDate"],
        tempValue: double.parse( json["tempValue"].toString() ) ,
        measureMode: json["measureMode"],
        enPassKind: json["enPassKind"],
        id: json["id"],
        upload: json["upload"]
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "dtcDate": dtcDate,
        "tempValue": tempValue,
        "measureMode": measureMode,
        "enPassKind": enPassKind,
        "id": id,
        "upload": upload ?? 0
    };
}
