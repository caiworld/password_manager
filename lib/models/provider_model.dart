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
  ColorSwatch get theme =>
      Global.themes.firstWhere((e) => e.value.toString() ==
          Global.getBySharedPreferences("theme"), orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
set theme (ColorSwatch color){
  if(color != theme){
    Global.saveBySharedPreferences("theme", color[500].value.toString());
    notifyListeners();
  }
}
}