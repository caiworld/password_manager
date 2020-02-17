import 'package:dio/dio.dart';
import 'package:password_manager/models/pwdManager.dart';

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
    Response<Map> r = await dio.post<Map>("/mail/send",
        data: {"recipient": account, "subject": subject, "content": content});
    Map map = r.data;
    print(map);
    return map;
  }
}
