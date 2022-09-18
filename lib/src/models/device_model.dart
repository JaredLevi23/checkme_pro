// To parse this JSON data, do
//
//     final deviceModel = deviceModelFromJson(jsonString);

import 'dart:convert';

class DeviceModel {
    DeviceModel({
        required this.name,
        required this.type,
        required this.uuid,
        required this.rssi,
        required this.advName,
    });

    String name;
    String type;
    String uuid;
    String rssi;
    String advName;

    factory DeviceModel.fromRawJson(String str) => DeviceModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        name: json["name"],
        type: json["type"],
        uuid: json["UUID"],
        rssi: json["RSSI"],
        advName: json["advName"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "UUID": uuid,
        "RSSI": rssi,
        "advName": advName,
    };
}
