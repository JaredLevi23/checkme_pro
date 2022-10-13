import 'dart:convert';
import 'dart:io';

import 'package:checkme_pro_develop/src/models/temperature_model.dart';

class TmpListModel {
    TmpListModel({
        required this.tmpList,
        required this.type,
    });

    List<TemperatureModel> tmpList;
    String type;

    factory TmpListModel.fromRawJson(String str) => TmpListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TmpListModel.fromJson(Map<String, dynamic> jsonMap) => TmpListModel(
        type: jsonMap["type"],
        //tmpList: List<TemperatureModel>.from(json["tmpList"].map((x) => TemperatureModel.fromJson(x))),
        tmpList: Platform.isIOS ?
        List<TemperatureModel>.from(jsonMap["tmpList"].map((x) => TemperatureModel.fromJson(x)))
        : List<TemperatureModel>.from( json.decode( jsonMap["tmpList"] ).map( (x) => TemperatureModel.fromJson( x ) ) ),
    );

    Map<String, dynamic> toJson() => {
        "tmpList": List<dynamic>.from(tmpList.map((x) => x.toJson())),
        "type": type,
    };
}