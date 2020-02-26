import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/service/http_service.dart';
import 'package:password_manager/service/local_authentication_service.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() {
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {

  final LocalAuthenticationService _localAuth = LocalAuthenticationService();

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
              // TODO ClipOval ?当没使用该控件时，打开侧边栏时会闪一下
              child: ClipOval(
                child: Image.asset(
                  "imgs/ic_launcher.png",
                  width: 80,
                  height: 80,
                ),
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
    // TODO 设置成只显示一行，当有多余的时候，就让文字滚动显示
    return Text(
      account ?? "绑定邮箱",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  /// 构建功能菜单 TODO 导入恢复密码设置、一键发送所有密码到邮箱的设置、添加主题设置、中英文设置
  ///  TODO 探索没有网络时的情况、不设置邮箱的情况
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
        ),
        ListTile(
//          leading: const Icon(Icons.sync),
          leading: const Icon(Icons.backup),
          title: Text("同步所有密码到邮箱"),
          onTap: _backup,
        ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: Text("导入密码"),
          onTap: () {
            // 跳转到新页面
            Navigator.of(context).pushNamed("RestorePasswordRoute");
          },
        ),
        ListTile(
          leading: const Icon(Icons.fingerprint),
          title: Text("指纹登录"),
          onTap: () async{
            Utils.showToast("开通指纹登陆");
            await _localAuth.authenticate();
          },
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text("国际化"),
          onTap: () {
            Utils.showToast("设置国际化");
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback),
          title: Text("反馈意见"),
          onTap: () {
            Utils.showToast("反馈意见");
          },
        )
      ],
    );
  }

  /// 同步所有密码到邮箱
  Future _backup() async {
    // 先看有没有绑定邮箱，没有绑定的话给出提示（要不要再跳转到绑定邮箱页面?）
    String account = Global.getBySharedPreferences("account");
    if (account != null && account.isNotEmpty) {
      // 绑定邮箱后弹窗确认
      bool result = await _showBackupDialog();
      if (result != null && result) {
        // result为true表示确认备份
        // 弹出加载框
        Utils.showLoading(context, "备份中，请稍候...");
        // 发送备份请求
        HttpService httpService = HttpService();
        Map result = await httpService.backupPassword();
        // 关闭加载框
        Navigator.of(context).pop();
        // 吐司备份结果
        Utils.showToast(result["msg"]);
      }
    } else {
      Utils.showToast("请先绑定邮箱！");
      // TODO 要不要跳转到绑定邮箱页面?
    }
  }

  /// 展示备份弹窗
  Future<bool> _showBackupDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("备份"),
            content: Text("你确定要备份所有密码到邮箱吗?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("确定"),
              ),
            ],
          );
        });
  }
}
