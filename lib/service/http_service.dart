import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/models/pwdManager.dart';
import 'package:password_manager/service/pwd_manager_service.dart';

class HttpService {
  static Dio dio = Dio(BaseOptions(
    baseUrl: "http://hospital.4kb.cn/",
  ));

  /// 测试
  Future<String> test() async {
    var result = await dio.get("/test");
    print(result);
    return result.toString();
  }

  /// 发送密码
  Future<Map> sendPassword(
      String account, String subject, String content) async {
    Response<Map> r;
    Map map;
    try {
      r = await dio.post<Map>("/mail/send",
          data: {"recipient": account, "subject": subject, "content": content});
      map = r.data;
      print(map);
    } catch (e) {
      // TODO 捕捉网络DIO异常，查看网上解决方案
      print(e);
      map = Map();
      map["msg"] = "服务器异常，请稍候重试";
    }
    return map;
  }

  /// 备份密码到邮箱
  Future<Map> backupPassword() async {
    // 首先查询出所有密码
    List<Map<String, dynamic>> list = await PwdManagerService.selectAll();
    // 然后发送所有密码到邮箱
    String account = Global.getBySharedPreferences("account");
    Map result =
        await sendPassword(account, "备份所有密码", json.encode(list));
    return result;
  }
}
