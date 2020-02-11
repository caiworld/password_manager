import 'dart:io';

import 'package:flutter/material.dart';
import 'package:password_manager/common/utils.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // 移除顶部padding
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 构建抽屉菜单头部
              _buildHeader(context),
              // 构建功能菜单
              Expanded(child: _buildMenus()),
            ],
          )),
    );
  }

  /// 构建菜单头部
  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                "imgs/ic_launcher.png",
                width: 80,
              ),
            ),
            Text(
              "密码管理",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      onTap: () {
        Utils.showToast("密码管理工具");
      },
    );
  }

  /// 构建功能菜单
  Widget _buildMenus() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: Text("主题"),
          onTap: () => {Utils.showToast("切换主题")},
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: Text("修改密码"),
          onTap: () => Utils.showToast("修改密码"),
        )
      ],
    );
  }
}
