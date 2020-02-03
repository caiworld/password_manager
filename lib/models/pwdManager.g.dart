// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pwdManager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PwdManager _$PwdManagerFromJson(Map<String, dynamic> json) {
  return PwdManager()
    ..id = json['id'] as num
    ..title = json['title'] as String
    ..account = json['account'] as String
    ..password = json['password'] as String
    ..salt = json['salt'] as String
    ..createTime = json['createTime'] as String
    ..updateTime = json['updateTime'] as String;
}

Map<String, dynamic> _$PwdManagerToJson(PwdManager instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'account': instance.account,
      'password': instance.password,
      'salt': instance.salt,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime
    };
