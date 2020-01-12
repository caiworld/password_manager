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
      password text
    )
      """;
  }

  @override
  String tableName() {
    return _tableName;
  }

  /// 插入数据
  Future insert() async {
    Database db = await getDatabase();
    PwdManager pwdManager = PwdManager.fromJson(
        {"id": Null, "title": "工商银行", "account": "ICBC", "password": "123456"});
    int i = await db.insert(_tableName, pwdManager.toJson());
    print("插入$i条数据");
  }

  Future select() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> list = await db.query(_tableName);
    print(list);
  }
}
