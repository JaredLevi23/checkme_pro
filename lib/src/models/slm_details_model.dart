import 'dart:convert';

import 'dart:io';

class SlmDetailsModel {
    SlmDetailsModel({
        required this.arrPrValue,
        required this.arrOxValue,
        required this.dtcDate,
        this.id
    });

    int? id;
    List arrPrValue;
    List arrOxValue;
    String dtcDate;

    factory SlmDetailsModel.fromRawJson(String str) => SlmDetailsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SlmDetailsModel.fromJson(Map<String, dynamic> jsonMap) => SlmDetailsModel(
        arrPrValue: Platform.isIOS 
          ? List<int>.from(jsonMap["arrPrValue"].map((x) => x))
          : List<int>.from(json.decode( jsonMap["arrPrValue"] ).map((x) => x)),
        arrOxValue: Platform.isIOS
          ? List<int>.from(jsonMap["arrOxValue"].map((x) => x))
          : List<int>.from(json.decode( jsonMap["arrOxValue"]).map((x) => x)),
        dtcDate: jsonMap["dtcDate"],
        id: jsonMap["id"]
    );

    factory SlmDetailsModel.fromJsonDB(Map<String, dynamic> jsonMap) => SlmDetailsModel(
        arrPrValue: List<int>.from(json.decode( jsonMap["arrPrValue"] ).map((x) => x)),
        arrOxValue: List<int>.from(json.decode( jsonMap["arrOxValue"]).map((x) => x)),
        dtcDate: jsonMap["dtcDate"],
        id: jsonMap["id"]
    );

    Map<String, dynamic> toJson() => {
        "arrPrValue": List<dynamic>.from(arrPrValue.map((x) => x)).toString(),
        "arrOxValue": List<dynamic>.from(arrOxValue.map((x) => x)).toString(),
        "dtcDate": dtcDate,
        "id": id
    };
}
