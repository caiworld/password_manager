import 'package:json_annotation/json_annotation.dart';

part 'pwdManager.g.dart';

@JsonSerializable()
class PwdManager {
    PwdManager();

    num id;
    String title;
    String account;
    String password;
    String salt;
    
    factory PwdManager.fromJson(Map<String,dynamic> json) => _$PwdManagerFromJson(json);
    Map<String, dynamic> toJson() => _$PwdManagerToJson(this);
}
