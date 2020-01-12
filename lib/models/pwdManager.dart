import 'package:json_annotation/json_annotation.dart';

part 'pwdManager.g.dart';

@JsonSerializable()
class PwdManager {
    PwdManager();

    int id;
    String title;
    String account;
    String password;
    
    factory PwdManager.fromJson(Map<String,dynamic> json) => _$PwdManagerFromJson(json);
    Map<String, dynamic> toJson() => _$PwdManagerToJson(this);
}
