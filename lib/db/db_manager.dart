import 'dart:io';

import 'package:sqflite/sqflite.dart';

/// 参考：https://blog.csdn.net/qq_19979101/article/details/93030803
/// 数据库操作基类
/// DBManger类，将数据库的创建，关闭等基础操作同一封装在一个类中统一管理
///
class DBManager {
  /// 数据库版本
  static const int _VERSION = 1;

  /// 数据库名称
  static const String _DB_NAME = "pwd_manager.db";

  static Database _database;

  /// 初始化
  static init() async {
    // 获取本地数据库位置
    var databasePath = await getDatabasesPath();
    String path = databasePath + _DB_NAME;
    if (Platform.isIOS) {
      path = databasePath + "/" + _DB_NAME;
    }
    // 打开数据库
    _database = await openDatabase(path, version: _VERSION,
        onCreate: (Database db, int version) async {
      // TODO 可以在这里创建表
    });
  }

  /// 获取当前数据库连接
  static getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  /// 判断指定表是否已经存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    String sql =
        "select * from Sqlite_master where type = 'table' and name = '$tableName'";
    var res = await _database.rawQuery(sql);
    return res != null && res.length > 0;
  }

  /// 关闭当前数据库连接
  static close() {
    _database?.close();
    _database = null;
  }
}
