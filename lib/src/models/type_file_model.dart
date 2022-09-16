
import 'dart:convert';

class TypeFileModel{
  final String type;
  TypeFileModel({ required this.type, });

    factory TypeFileModel.fromRawJson(String str) => TypeFileModel.fromJson(json.decode(str));
    String toRawJson() => json.encode(toJson());

    factory TypeFileModel.fromJson(Map<String, dynamic> json) => TypeFileModel(
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
    };
}