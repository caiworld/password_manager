import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  // 保存数据的 SharedPreference
  static SharedPreferences _prefs;

  static String pwdMd5;

  /// 初始化全局信息
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
//    savePassword("123456");
  }

  /// 保存用户终极密码
  static void savePassword(String password) {
    String value = EncryptDecryptUtils.md5Thousand(password);
    _prefs.setString("password", value);
  }

  /// 通过 SharedPreferences 保存数据
  static Future<bool> saveBySharedPreferences(String key, String value) {
    return _prefs.setString(key, value);
  }

  /// 获取用户终极密码
  static String getPwdMd5() {
    // TODO 优化：将获取到的密码赋值给全局变量，这样获取时可以先判断有没有获取过，
    //  获取过的话就不用重新获取了
    if (pwdMd5 == null || pwdMd5 == "") {
      pwdMd5 = _prefs.getString("password");
      return pwdMd5;
    }
    return pwdMd5;
  }
}
