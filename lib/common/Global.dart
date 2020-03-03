import 'package:flutter/material.dart';
import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 提供5套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

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

  /// 通过 SharedPreferences 保存 string 数据
  static Future<bool> saveBySharedPreferences(String key, String value) {
    return _prefs.setString(key, value);
  }

  /// 获取 SharedPreferences 保存 string 的数据
  static String getBySharedPreferences(String key) {
    return _prefs.getString(key);
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

  /// 通过 SharedPreferences 保存 bool 数据
  static Future<bool> saveBoolBySharedPreferences(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  /// 获取 SharedPreferences 保存 bool 的数据
  static bool getBoolBySharedPreferences(String key) {
    return _prefs.getBool(key);
  }

  static List<MaterialColor> get themes => _themes;
}
