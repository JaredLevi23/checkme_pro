
// To parse this JSON data, do
//
//     final BtStateModel = BtStateModelFromJson(jsonString);

import 'dart:convert';

class BtStateModel {
    BtStateModel({
        required this.value,
        required this.type,
    });

    String value;
    String type;

    factory BtStateModel.fromRawJson(String str) => BtStateModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BtStateModel.fromJson(Map<String, dynamic> json) => BtStateModel(
        value: json["value"],
        type: json["type"]
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "type": type
    };
}
