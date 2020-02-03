import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:password_manager/dao/pwd_manager_dao.dart';
import 'package:password_manager/models/index.dart';

class PwdManagerService {
  static PwdManagerDao _pwdManagerDao = new PwdManagerDao();

  /// 插入数据
  static Future<int> insert(PwdManager pwdManager) async {
    PwdManager encryptedPwdManager = await EncryptDecryptUtils.encrypt(
        Global.getPwdMd5(), pwdManager.password);
    pwdManager.password = encryptedPwdManager.password;
    pwdManager.salt = encryptedPwdManager.salt;
    pwdManager.createTime = DateTime.now().toString();
    pwdManager.updateTime = DateTime.now().toString();
    return await _pwdManagerDao.insert(pwdManager);
  }

  static Future<List<PwdManager>> select(int page, {int pageSize}) async {
    List<Map<String, dynamic>> list;
    if (pageSize == null) {
      list = await _pwdManagerDao.select(page);
    } else {
      list = await _pwdManagerDao.select(page, pageSize: pageSize);
    }
    List<PwdManager> result = new List<PwdManager>();
    String pwdMd5 = Global.getPwdMd5();
    for (Map<String, dynamic> map in list) {
      PwdManager pwdManager = PwdManager.fromJson(map);
      pwdManager.password =
          await EncryptDecryptUtils.decrypt(pwdMd5, pwdManager);
      result.add(pwdManager);
    }
    return result;
  }
}
