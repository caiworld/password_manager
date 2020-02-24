import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:password_manager/dao/pwd_manager_dao.dart';
import 'package:password_manager/models/index.dart';

class PwdManagerService {
  static PwdManagerDao _pwdManagerDao = new PwdManagerDao();

  /// 插入数据
  static Future<int> insert(PwdManager oriPwdManager) async {
    PwdManager pwdManager = PwdManager.fromJson(oriPwdManager.toJson());
    PwdManager encryptedPwdManager = await EncryptDecryptUtils.encrypt(
        Global.getPwdMd5(), pwdManager.password);
    pwdManager.password = encryptedPwdManager.password;
    pwdManager.salt = encryptedPwdManager.salt;
    pwdManager.createTime = DateTime.now().toString();
    pwdManager.updateTime = DateTime.now().toString();
    return await _pwdManagerDao.insert(pwdManager);
  }

  /// 修改数据
  static Future<int> update(PwdManager oriPwdManager) async {
    PwdManager pwdManager = PwdManager.fromJson(oriPwdManager.toJson());
    PwdManager encryptedPwdManager = await EncryptDecryptUtils.encrypt(
        Global.getPwdMd5(), pwdManager.password);
    pwdManager.password = encryptedPwdManager.password;
    pwdManager.salt = encryptedPwdManager.salt;
    pwdManager.updateTime = DateTime.now().toString();
    return await _pwdManagerDao.update(pwdManager);
  }

  /// 查询数据
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

  static Future<List<Map<String, dynamic>>> selectAll() async {
    return _pwdManagerDao.selectAll();
  }

  /// 修改用户终极密码
  static Future<bool> updatePassword(
      String oldPassword, String newPassword) async {
    // 对新密码进行md5加密
    String newPwdMd5 = EncryptDecryptUtils.md5Thousand(newPassword);
    // 1.获取原先加密过的终极密码
    String oldPwdMd5 = Global.getPwdMd5();
    // 将原先加密过的终极密码与输入的原密码加密后进行对比
    String pwdMd5 = EncryptDecryptUtils.md5Thousand(oldPassword);
    if (oldPwdMd5 != pwdMd5) {
      // TODO 应该返回一个对象，光返回一个bool值不够用，还得加一个描述
      return false;
    }
    // 2.查询出所有原来的密码
    List<Map<String, dynamic>> oldList = await _pwdManagerDao.selectAll();
    if (oldList == null || oldList.length == 0) {
      print("没有添加过密码");
      // 保存新终极密码
      bool success =
          await Global.saveBySharedPreferences("password", newPwdMd5);
      return success;
    }
    List<PwdManager> list = List();
    for (int i = 0; i < oldList.length; i++) {
      Map<String, dynamic> pwdManager = oldList[i];
      // 修改密码相关信息
      PwdManager oldPwdManager = PwdManager.fromJson(pwdManager);
      PwdManager newPwdManager = PwdManager();
      newPwdManager.id = oldPwdManager.id;
      newPwdManager.title = oldPwdManager.title;
      newPwdManager.account = oldPwdManager.account;
      newPwdManager.createTime = oldPwdManager.createTime;
      newPwdManager.updateTime = oldPwdManager.updateTime;
      // 3.设置新的加密后的密码和密盐
      // 获取原密码
      String decryptPassword =
          await EncryptDecryptUtils.decrypt(oldPwdMd5, oldPwdManager);
      // 用md5终极密码对原密码进行加密
      PwdManager encryptPwdManager =
          await EncryptDecryptUtils.encrypt(newPwdMd5, decryptPassword);
      newPwdManager.password = encryptPwdManager.password;
      newPwdManager.salt = encryptPwdManager.salt;
      list.add(newPwdManager);
    }
    // 存储修改后的密码相关信息
    var result = await _pwdManagerDao.updatePatch(list, newPwdMd5);
    print("修改用户终极密码：$result");
    return true;
  }

  /// 通过id获取密码
  static Future<List<Map<String, dynamic>>> getPwdById(int id) async {
    return _pwdManagerDao.selectPwdById(id);
  }

  /// 添加多个PwdManager
  static Future<bool> addPwdManagerList(List<PwdManager> list) async {
    return _pwdManagerDao.insertBatch(list);
  }
}
