import 'dart:io';

import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();
  bool _isProtectionEnabled = false;

  bool get isProtectionEnabled => _isProtectionEnabled;

  set isProtectionEnabled(bool enabled) => _isProtectionEnabled = enabled;

  bool isAuthenticated = false;

  Future<void> authenticate() async {
    if (_isProtectionEnabled) {
      try {
        List<BiometricType> avaliableBiometricList =
                  await _auth.getAvailableBiometrics();
        if (Platform.isIOS) {
                // IOS
              }
        isAuthenticated = await _auth.authenticateWithBiometrics(
                localizedReason: "请验证指纹",
                useErrorDialogs: true,
                stickyAuth: true,
              );
        print(isAuthenticated);
      } catch (e) {
        print(e);
      }
    }
  }
}
