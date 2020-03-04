import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart'; // 1

class MyLocalizations {

  static Future<MyLocalizations> load(Locale locale){
    final String name = locale.countryCode.isEmpty?locale.languageCode:locale.toString();
    final String localName = Intl.canonicalizedLocale(name);

    // 2
    return initializeMessages(localName).then((b){
      Intl.defaultLocale = localName;
      return new MyLocalizations();
    });
  }

  static MyLocalizations of(BuildContext context){
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  String get title{
    return Intl.message("password_manager",name: 'title',desc: "app's name");
  }

  String get name{
    return Intl.message("name",name: "name",desc: "name");
  }
}

// Locale代理类
class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations>{
  /// 是否支持某个Locale
  @override
  bool isSupported(Locale locale) {
    return ['zh','en'].contains(locale.languageCode);
  }

  /// flutter会调用此类加载相应的Locale资源
  @override
  Future<MyLocalizations> load(Locale locale) {
    // 3
    return MyLocalizations.load(locale);
  }

  /// 当Localizations Widget重新build时，是否调用load重新加载Locale资源
  @override
  bool shouldReload(LocalizationsDelegate<MyLocalizations> old) {
    return false;
  }

}