import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/service/local_authentication_service.dart';

/// 账户管理页面
class AccountManagerRoute extends StatefulWidget {
  @override
  _AccountManagerRouteState createState() => _AccountManagerRouteState();
}

class _AccountManagerRouteState extends State<AccountManagerRoute> {
  TextEditingController _accountController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool sendAll = (Global.getBySharedPreferences("type") ?? "one") == "all";

  /// 是否开通指纹登录
  bool fingerprintAuth =
      Global.getBoolBySharedPreferences("fingerprintAuth") ?? false;

  final LocalAuthenticationService _localAuth = LocalAuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("邮箱管理"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                // 校验邮箱
                if (_formKey.currentState.validate()) {
                  // TODO 进行邮箱在线校验
                  // 保存邮箱
                  await Global.saveBySharedPreferences(
                      "account", _accountController.text);
                  // 保存发送密码的形式
                  await Global.saveBySharedPreferences(
                      "type", sendAll ? "all" : "one");
                  Utils.showToast("保存成功");
                  Navigator.of(context).pop();
                }
              }),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _accountController
                    ..text = Global.getBySharedPreferences("account") ?? "",
                  decoration: InputDecoration(
                    labelText: "邮箱",
                    hintText: "请输入邮箱",
                    prefixIcon: Icon(Icons.email),
                  ),
                  autovalidate: true,
                  validator: (value) {
                    return isEmail(value);
                  },
                ),
                Row(
                  children: <Widget>[
                    Text("仅发送新增时的密码"),
                    Switch(
                      value: sendAll,
                      onChanged: (bool val) {
                        this.setState(() {
                          sendAll = val;
                        });
                      },
                    ),
                    Text("每次发送所有密码"),
                  ],
                ),
//                SwitchListTile(
//                  title: Text("仅发送新增时的密码 / 每次发送所有密码"),
//                  selected: true,
//                  value: sendAll,
//                  onChanged: (bool val) {
//                    this.setState(() {
//                      sendAll = val;
//                    });
//                  },
//                ),
                CheckboxListTile(
                  value: fingerprintAuth,
                  onChanged: (newValue) async {
                    // 校验该手机是否支持指纹登陆
                    bool canCheckBiometrics =
                        await _localAuth.checkBiometrics();
                    if (!canCheckBiometrics) {
                      return;
                    }
                    // 进行指纹校验
                    bool isAuthenticate = await _localAuth.authenticate();
                    // 校验成功更新选择框
                    if (isAuthenticate) {
                      Global.saveBoolBySharedPreferences(
                          "fingerprintAuth", newValue);
                      setState(() {
                        fingerprintAuth = newValue;
                      });
                    }
                  },
                  title: Text('开通指纹登录'),
                  selected: true,
                  secondary: Icon(Icons.fingerprint),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 邮箱正则
  final String regexEmail =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  /// 检查是否是邮箱格式
  String isEmail(String input) {
    if (input == null || input.isEmpty) {
      return "邮箱不能为空";
    }
    return RegExp(regexEmail).hasMatch(input) ? null : "邮箱格式不正确";
  }
}
