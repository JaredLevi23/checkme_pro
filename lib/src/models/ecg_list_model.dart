import 'dart:convert';
import 'models.dart';

class EcgListModel {
    EcgListModel({
        required this.type,
        required this.ecgList,
    });

    final String type;
    final List<EcgModel> ecgList;

    factory EcgListModel.fromRawJson(String str) => EcgListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EcgListModel.fromJson(Map<String, dynamic> json) => EcgListModel(
        type: json["type"],
        ecgList: List<EcgModel>.from(json["ecgList"].map((x) => EcgModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "ecgList": List<dynamic>.from(ecgList.map((x) => x.toJson())),
    };
}