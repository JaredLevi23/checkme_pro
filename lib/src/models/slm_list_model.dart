import 'dart:convert';
import 'dart:io';
import 'models.dart';

class SlmListModel {
  
    SlmListModel({
      required this.type,
      required this.slmList,
    });

    final String type;
    final List<SlmModel> slmList;

    factory SlmListModel.fromRawJson(String str) => SlmListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SlmListModel.fromJson(Map<String, dynamic> jsonMap) => SlmListModel(
        type: jsonMap["type"],
        //slmList: List<SlmModel>.from(json["slmList"].map((x) => SlmModel.fromJson(x))),
        slmList: Platform.isIOS ?
        List<SlmModel>.from(jsonMap["slmList"].map((x) => SlmModel.fromJson(x)))
        : List<SlmModel>.from( json.decode( jsonMap["slmList"] ).map( (x) => SlmModel.fromJson( x ) ) ),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "slmList": List<dynamic>.from(slmList.map((x) => x.toJson())),
    };

}