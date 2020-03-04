import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';

class HomeRefreshModel extends ChangeNotifier {
  bool homeRefresh = false;

  bool get refresh => homeRefresh;

  set refresh(bool homeRefresh) {
    homeRefresh = homeRefresh;
    notifyListeners();
  }
}

class ThemeModel extends ChangeNotifier {
  // 获取当前主题，如果未设置主题，则默认使用蓝色主题
  ColorSwatch get theme => Global.themes.firstWhere(
      (e) => e.value.toString() == Global.getBySharedPreferences("theme"),
      orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      Global.saveBySharedPreferences("theme", color[500].value.toString());
      notifyListeners();
    }
  }
}

class LocaleModel extends ChangeNotifier {
  /// 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale getLocale() {
    String localeStr = Global.getBySharedPreferences("locale");
    if (localeStr == null) {
      return null;
    }
    var t = localeStr.split("_");
    return Locale(t[0], t[1]);
  }

  /// 用户改变app语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    String localeStr = Global.getBySharedPreferences("locale");
    if (locale != localeStr) {
      Global.saveBySharedPreferences("locale", locale);
      notifyListeners();
    }
  }
}
