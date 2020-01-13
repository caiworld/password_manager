import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:password_manager/models/index.dart';

class EncryptDecryptUtils {
  static final cryptor = new PlatformStringCryptor();

  /// 加密
  static Future<PwdManager> encrypt(String pwdMd5, String content) async {
    // 获取随机密盐
    String salt = await cryptor.generateSalt();
    // 根据密码和密盐获取密钥
    String key = await cryptor.generateKeyFromPassword(pwdMd5, salt);
    // 通过密钥加密
    String result = await cryptor.encrypt(content, key);
    PwdManager pwdManager = new PwdManager();
    pwdManager.salt = salt;
    pwdManager.password = result;
    return pwdManager;
  }

  /// 解密
  static Future<String> decrypt(String pwdMd5, PwdManager pwdManager) async {
    String key = await cryptor.generateKeyFromPassword(pwdMd5, pwdManager.salt);
    String result = await cryptor.decrypt(pwdManager.password, key);
    return result;
  }

  /// MD5一千次
  static String md5Thousand(String content) {
    var digest;
    var contentList;
    for (int i = 0; i < 1000; i++) {
      contentList = new Utf8Encoder().convert(content);
      digest = md5.convert(contentList);
      content = hex.encode(digest.bytes);
    }
    String result = hex.encode(digest.bytes);
    print("MD5加密1000次：$result");
    return result;
  }
}
