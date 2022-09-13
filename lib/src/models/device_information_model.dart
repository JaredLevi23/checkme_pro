
import 'dart:convert';

DeviceInformationModel deviceInformationModelFromJson(String str) => DeviceInformationModel.fromJson(json.decode(str));

String deviceInformationModelToJson(DeviceInformationModel data) => json.encode(data.toJson());

class DeviceInformationModel {
    DeviceInformationModel({
        required this.model,
        required this.spcPVer,
        required this.software,
        required this.application,
        required this.theCurLanguage,
        required this.sn,
        required this.region,
        required this.hardware,
        required this.fileVer,
        required this.branchCode,
        required this.language,
    });

    final String model;
    final String spcPVer;
    final String software;
    final String application;
    final String theCurLanguage;
    final String sn;
    final String region;
    final String hardware;
    final String fileVer;
    final String branchCode;
    final String language;

    factory DeviceInformationModel.fromRawJson(String str) => DeviceInformationModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DeviceInformationModel.fromJson(Map<String, dynamic> json) => DeviceInformationModel(
        model: json["model"],
        spcPVer: json["spcPVer"],
        software: json["software"],
        application: json["application"],
        theCurLanguage: json["theCurLanguage"],
        sn: json["sn"],
        region: json["region"],
        hardware: json["hardware"],
        fileVer: json["fileVer"],
        branchCode: json["branchCode"],
        language: json["language"],
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "spcPVer": spcPVer,
        "software": software,
        "application": application,
        "theCurLanguage": theCurLanguage,
        "sn": sn,
        "region": region,
        "hardware": hardware,
        "fileVer": fileVer,
        "branchCode": branchCode,
        "language": language,
    };
}
