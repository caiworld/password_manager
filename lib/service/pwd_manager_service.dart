import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:password_manager/dao/pwd_manager_dao.dart';
import 'package:password_manager/models/index.dart';

class PwdManagerService {
  static PwdManagerDao _pwdManagerDao = new PwdManagerDao();

  /// 插入数据
  static Future<int> insert(PwdManager pwdManager) async {
    // TODO 需要从 SharedPreference 中获取 pwdMD5 的值
    EncryptDecryptUtils.encrypt(pwdMd5, pwdManager.password);
    return await _pwdManagerDao.insert(pwdManager);
  }

  static Future<List<Map<String, dynamic>>> select() async {
    return await _pwdManagerDao.select();
  }
}
