import 'dart:convert';

class SlmDetailsModel {
    SlmDetailsModel({
        required this.arrPrValue,
        required this.arrOxValue,
        required this.type,
    });

    List<int> arrPrValue;
    List<int> arrOxValue;
    String type;

    factory SlmDetailsModel.fromRawJson(String str) => SlmDetailsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SlmDetailsModel.fromJson(Map<String, dynamic> json) => SlmDetailsModel(
        arrPrValue: List<int>.from(json["arrPrValue"].map((x) => x)),
        arrOxValue: List<int>.from(json["arrOxValue"].map((x) => x)),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "arrPrValue": List<dynamic>.from(arrPrValue.map((x) => x)),
        "arrOxValue": List<dynamic>.from(arrOxValue.map((x) => x)),
        "type": type,
    };
}
