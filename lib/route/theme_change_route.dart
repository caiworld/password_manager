import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/models/provider_model.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatefulWidget {
  @override
  _ThemeChangeRouteState createState() => _ThemeChangeRouteState();
}

class _ThemeChangeRouteState extends State<ThemeChangeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("切换主题"),
      ),
      body: ListView(
        children: Global.themes.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              child: Container(
                color: e,
                height: 40.0,
              ),
            ),
            onTap: () {
              // 主题更新后，MaterialApp会重新构建
              Provider.of<ThemeModel>(context).theme = e;
            },
          );
        }).toList(),
      ),
    );
  }
}
