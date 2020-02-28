import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/main.dart';
import 'package:password_manager/service/http_service.dart';
import 'package:password_manager/service/local_authentication_service.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() {
    return _LoginRouteState();
  }
}

class _LoginRouteState extends State<LoginRoute> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();
  bool pwdShow = false;

  /// 是否开通指纹登录
  bool fingerprintAuth =
      Global.getBoolBySharedPreferences("fingerprintAuth") ?? false;

  final LocalAuthenticationService _localAuth = LocalAuthenticationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () async {
      // 检查服务器是否不更新
      HttpService httpService = HttpService();
      if(await httpService.checkNotUpdate()){
        return true;
      }
      bool later = true;
      bool flag = await showDialog(
          // 点击空白不关闭弹窗
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("更新"),
              content: Text("服务器有新版本，是否现在更新?"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    later = true;
                    Navigator.of(context).pop(true);
                  },
                  child: Text("否"),
                ),
                FlatButton(
                  onPressed: () {
                    later = false;
                    // 更新app
                    httpService.launchURL();
                    Navigator.of(context).pop(false);
                  },
                  child: Text("是"),
                ),
              ],
            );
          });
      print("login:later:$later");
      print("login:flag:$flag");
      return later;
    }).then((v) async {
      // 先判断是否设置过指纹登录
      if (v && fingerprintAuth) {
        // 校验目前能否进行指纹验证
        bool canCheckBiometrics = await _localAuth.checkBiometrics();
        if (canCheckBiometrics) {
          // 进行指纹验证
          bool isAuthenticate = await _localAuth.authenticate();
          if (isAuthenticate) {
            // 指纹验证成功，跳转首页
            Navigator.of(context).pushReplacementNamed("MyHomePageRoute");
          } else {
            // 指纹不成功
            Utils.showToast("指纹验证失败，请尝试密码登录");
          }
        } else {
          // 表名当前不能进行指纹验证
          // 修改进行指纹登录的标记
          Global.saveBoolBySharedPreferences("fingerprintAuth", false);
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _controller..text = "123456",
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      }),
                ),
                obscureText: !pwdShow,
                validator: (value) {
                  return value.trim().isNotEmpty ? null : "密码不能为空";
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55),
                  child: RaisedButton(
                    onPressed: _login,
                    child: Text("登录"),
                  ),
                ),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 55),
                    child: RaisedButton(
                      onPressed: _fingerprintAuth,
                      child: Text("指纹登录"),
                    ),
                  ),
                ),
                visible: Global.getBoolBySharedPreferences("fingerprintAuth") ??
                    false,
              )
            ],
          ),
        ),
      ),
    );
  }

  _login() {
    if (_formKey.currentState.validate()) {
      if (Global.getPwdMd5() ==
          EncryptDecryptUtils.md5Thousand(_controller.text)) {
        Navigator.of(context).pushReplacementNamed("MyHomePageRoute");
      } else {
        Utils.showToast("密码有误，请确认");
      }
    }
  }

  _fingerprintAuth() async {
    // 校验目前能否进行指纹验证
    bool canCheckBiometrics = await _localAuth.checkBiometrics();
    if (canCheckBiometrics) {
      // 进行指纹验证
      bool isAuthenticate = await _localAuth.authenticate();
      if (isAuthenticate) {
        // 指纹验证成功，跳转首页
        Navigator.of(context).pushReplacementNamed("MyHomePageRoute");
      } else {
        // 指纹不成功
        Utils.showToast("指纹验证失败，请尝试密码登录");
      }
    } else {
      // 表名当前不能进行指纹验证
      // 修改进行指纹登录的标记
      Global.saveBoolBySharedPreferences("fingerprintAuth", false);
      Utils.showToast("暂未设置指纹登录或手机不支持指纹验证，请尝试密码登录");
    }
  }
}
