import 'package:password_manager/common/Global.dart';
import 'package:password_manager/db/base_db_provider.dart';
import 'package:password_manager/models/index.dart';
import 'package:sqflite/sqflite.dart';

class PwdManagerDao extends BaseDBProvider {
  final String _tableName = "pwd_manager";

  @override
  String createSql() {
    return """
    CREATE TABLE $_tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title text,
      account text,
      password text,
      salt text,
      createTime text,
      updateTime text
    )
      """;
  }

  @override
  String tableName() {
    return _tableName;
  }

  /// 插入数据
  Future<int> insert(PwdManager pwdManager) async {
    Database db = await getDatabase();
    try {
      int id = 0;
      for (int i = 0; i < 1; i++) {
        id = await db.insert(_tableName, pwdManager.toJson());
      }
      print("插入的数据的id：$id");
      return id;
    } catch (e) {
      print("dao插入数据失败，失败原因：{$e}");
    }
    return 1;
  }

  /// 修改数据
  Future<int> update(PwdManager pwdManager) async {
    Database db = await getDatabase();
    try {
      int line = await db.update(_tableName, pwdManager.toJson(),
          where: "id=?", whereArgs: [pwdManager.id]);
      print("修改：$line");
    } catch (e) {
      print("dao修改数据失败，失败原因：{$e}");
    }
    return 1;
  }

  /// 查询数据
  Future<List<Map<String, dynamic>>> select(int page,
      {int pageSize = 20}) async {
    Database db = await getDatabase();
//    List<Map<String, dynamic>> list = await db.query(
//      _tableName,
//      limit: pageSize,
//      offset: (page - 1) * pageSize,
//    );
//    print(list);
    List<Map<String, dynamic>> list = await db.rawQuery(
        "select * from pwd_manager order by updateTime desc limit ? offset ?",
        [pageSize, (page - 1) * pageSize]);
    return list;
  }

  /// 查询所有数据
  Future<List<Map<String, dynamic>>> selectAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> list = await db.query(_tableName);
    print(list);
    return list;
  }

  ///
  /// 批量修改
  /// password 为用户终极密码
  ///
  Future updatePatch(List<PwdManager> list, String pwdMd5) async {
    print("list:$list");
    Database db = await getDatabase();
    var result = await db.transaction((txn) async {
      Batch batch = txn.batch();
      list.forEach((pwdManager) => batch.update(_tableName, pwdManager.toJson(),
          where: "id=?", whereArgs: [pwdManager.id]));
      // 修改用户终极密码
      Global.saveBySharedPreferences("password", pwdMd5);
      var result = await batch.commit();
      print("批量修改1：$result");
      return result;
    });
    print("批量修改2：$result");
    bool success = true;
    for (int i = 0; i < result.length; i++) {
      if (result[i] < 1) {
        success = false;
        break;
      }
    }
    if (success) {
      Global.pwdMd5 = pwdMd5;
    }
    return success;
  }

  /// 通过 id 查询密码
  Future<List<Map<String, dynamic>>> selectPwdById(int id) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> list =
        await db.rawQuery("select * from $_tableName where id = ?", [id]);
    return list;
  }
}
