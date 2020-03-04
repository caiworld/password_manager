import 'package:flutter/material.dart';
import 'package:password_manager/i10n/localization_intl.dart';
import 'package:password_manager/models/provider_model.dart';
import 'package:provider/provider.dart';

class LanguageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    var localeModel = Provider.of<LocaleModel>(context);
    MyLocalizations myLocalizations = MyLocalizations.of(context);
    //构建语言选择项
    Widget _buildLanguageItem(String lan, value) {
      return ListTile(
        title: Text(
          lan,
          // 对APP当前语言进行高亮显示
          style: TextStyle(
              color:
                  localeModel.getLocale().toString() == value ? color : null),
        ),
        trailing: localeModel.getLocale() == null ||
                localeModel.getLocale().toString() == value
            ? Icon(Icons.done, color: color)
            : null,
        onTap: () {
          // 更新locale后MaterialApp会重新build
          localeModel.locale = value;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(myLocalizations.title),
      ),
      body: ListView(
        children: <Widget>[
          _buildLanguageItem("中文简体", "zh_CN"),
          _buildLanguageItem("English", "en_US"),
          _buildLanguageItem(myLocalizations.title, null),
        ],
      ),
    );
  }
}
