import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/models/pwdManager.dart';
import 'package:password_manager/service/pwd_manager_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HttpService {
  static Dio dio = Dio(BaseOptions(
    baseUrl: "http://hospital.4kb.cn/password_manager",
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
    Map result = await sendPassword(account, "备份所有密码", json.encode(list));
    return result;
  }

  /// 打开浏览器下载最新apk
  launchURL() async {
    const url = 'https://hospital.4kb.cn/password-manager-debug.apk';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// 检查是否需要更新
  Future<bool> checkNotUpdate() async {
    const url = "/app/getAppVersion";
    Response<String> r;
    try {
      r = await dio.get(url);
      String serverAppVersion = r.data;
      if (serverAppVersion == null || serverAppVersion.isEmpty) {
        // 服务器没有版本信息，表示不用更新
        return true;
      }
      // 获取本地app版本
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String localAppVersion = packageInfo.version;
      print("serverAppVersion:$serverAppVersion");
      print("localAppVersion:$localAppVersion");
      // 服务器app版本和本地app版本一样表示不用更新
      return serverAppVersion == localAppVersion;
    } catch (e) {
      print(e);
      Utils.showToast("服务器异常，请稍候重试");
      return true;
    }
  }
  /// 发送反馈
  Future<Map> sendFeedback(
      FormData formData, Map<String, dynamic> params) async {
//    Response<Map> r;
    Response r;
    Map map;
    try {
      r = await dio.post(
        '/app/sendFeedback2',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data;'},
        ),
      );
      map = r.data;
      print(map);
      print("----------------------$r");
    } catch (e) {
      print(e);
      Utils.showToast("服务器异常，请稍候重试");
      map = {"msg": "服务器异常，请稍候重试"};
    }
    return map;
  }
}
