import 'package:json_annotation/json_annotation.dart';

part 'pwdManager.g.dart';

@JsonSerializable()
class PwdManager {
    PwdManager();

    PwdManager.param({this.title,this.account,this.password,this.salt});

    num id;
    String title;
    String account;
    String password;
    String salt;
    String createTime;
    String updateTime;
    
    factory PwdManager.fromJson(Map<String,dynamic> json) => _$PwdManagerFromJson(json);
    Map<String, dynamic> toJson() => _$PwdManagerToJson(this);
}
