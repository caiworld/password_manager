import 'package:flutter/material.dart';
import 'package:password_manager/db/db_manager.dart';
import 'package:sqflite/sqlite_api.dart';

///
/// 参考：https://blog.csdn.net/qq_19979101/article/details/93030803
///
/// 数据表操作基类
/// BaseDBProvider类，这个类定义创建数据库表的基础方法；
/// 这个类是一个抽象类，把具体创建数据库表的sql暴露出去，让子类去具体实现；
/// 由它直接和DBManager打交道，业务层实现这个接口即可。
///
abstract class BaseDBProvider {
  bool isTableExist = false;

  /// 返回一个表名
  String tableName();

  ///  建表语句
  String createSql();

  /// 获取数据库
  Future<Database> getDatabase() async {
    return await open();
  }

  // TODO open()和 prepare()获取可以私有化 ?
  @mustCallSuper
  Future<Database> open() async {
    if (!isTableExist) {
      await prepare(tableName(), createSql());
    }
    return await DBManager.getCurrentDatabase();
  }

  @mustCallSuper
  prepare(String tableName, String createSql) async {
    isTableExist = await DBManager.isTableExits(tableName);
    if (!isTableExist) {
      Database db = await DBManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }
}
