import 'dart:convert';
import 'dart:io';
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

    factory EcgListModel.fromJson(Map<String, dynamic> jsonMap) => EcgListModel(
        type: jsonMap["type"],
        //ecgList: List<EcgModel>.from(json["ecgList"].map((x) => EcgModel.fromJson(x))),
        ecgList: Platform.isIOS ?
        List<EcgModel>.from(jsonMap["ecgList"].map((x) => EcgModel.fromJson(x)))
        : List<EcgModel>.from( json.decode( jsonMap["ecgList"] ).map( (x) => EcgModel.fromJson( x ) ) ),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "ecgList": List<dynamic>.from(ecgList.map((x) => x.toJson())),
    };
}