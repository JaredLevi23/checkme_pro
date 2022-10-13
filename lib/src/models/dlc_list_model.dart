import 'dart:convert';
import 'dart:io';
import 'package:checkme_pro_develop/src/models/dlc_model.dart';

class DlcListModel {
    DlcListModel({
        required this.dlcList,
        required this.type,
    });

    List<DlcModel> dlcList;
    String type;

    factory DlcListModel.fromRawJson(String str) => DlcListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DlcListModel.fromJson(Map<String, dynamic> jsonMap) => DlcListModel(
        type: jsonMap["type"],
        //dlcList: List<DlcModel>.from(json["dlcList"].map((x) => DlcModel.fromJson(x))),
        dlcList: Platform.isIOS ?
        List<DlcModel>.from(jsonMap["dlcList"].map((x) => DlcModel.fromJson(x)))
        : List<DlcModel>.from( json.decode( jsonMap["dlcList"] ).map( (x) => DlcModel.fromJson( x ) ) ),
    );

    Map<String, dynamic> toJson() => {
        "dlcList": List<dynamic>.from(dlcList.map((x) => x.toJson())),
        "type": type,
    };
}