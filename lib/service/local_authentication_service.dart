import 'dart:io';

import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();
  bool _isProtectionEnabled = true;

  bool get isProtectionEnabled => _isProtectionEnabled;

  set isProtectionEnabled(bool enabled) => _isProtectionEnabled = enabled;

  bool isAuthenticated = false;

  static const andStrings = const AndroidAuthMessages(
      fingerprintHint: "指纹",
      fingerprintNotRecognized: "指纹识别失败",
      fingerprintSuccess: "指纹识别成功",
      cancelButton: "取消",
      signInTitle: "指纹验证",
      fingerprintRequiredTitle: "请先录入指纹！",
      goToSettingsButton: "去设置",
      goToSettingsDescription: "请设置指纹");

  /// 检查是否有可用的生物识别技术（如指纹、人脸）
  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    return canCheckBiometrics;
  }

  /// 指纹校验
  Future<bool> authenticate() async {
    if (_isProtectionEnabled) {
      try {
        List<BiometricType> avaliableBiometricList =
            await _auth.getAvailableBiometrics();
        if (Platform.isIOS) {
          // IOS
        }
        isAuthenticated = await _auth.authenticateWithBiometrics(
          localizedReason: "请验证指纹进行登录",
          useErrorDialogs: true,
          stickyAuth: true,
          androidAuthStrings: andStrings,
        );
        print(isAuthenticated);
        return isAuthenticated;
      } catch (e) {
        print(e);
      }
    }
    return false;
  }
}
