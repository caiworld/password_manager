import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/models/index.dart';
import 'package:password_manager/service/http_service.dart';

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
              Expanded(child: _buildMenus(context)),
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
            _buildAccount(),
          ],
        ),
      ),
      onTap: () {
        Utils.showToast("密码管理工具");
        Navigator.of(context).pushNamed("AccountManagerRoute");
      },
    );
  }

  /// 构建邮箱账号
  Widget _buildAccount() {
    String account = Global.getBySharedPreferences("account");
    return Text(
      account ?? "绑定邮箱",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  /// 构建功能菜单
  Widget _buildMenus(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: Text("主题"),
          onTap: () async {
            Utils.showToast("切换主题");
            HttpService httpService = new HttpService();
            print(await httpService.test());
          },
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: Text("修改密码"),
          onTap: () {
            Navigator.of(context).pushNamed("UpdatePasswordRoute");
            Utils.showToast("修改密码");
          },
        )
      ],
    );
  }
}
