
import 'dart:convert';

class TypeFileModel{
  final String type;
  final String? message;
  TypeFileModel({ required this.type, this.message });

    factory TypeFileModel.fromRawJson(String str) => TypeFileModel.fromJson(json.decode(str));
    String toRawJson() => json.encode(toJson());

    factory TypeFileModel.fromJson(Map<String, dynamic> json) => TypeFileModel(
        type: json["type"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "message": message ?? ""
    };
}