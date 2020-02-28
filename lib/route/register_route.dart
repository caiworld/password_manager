import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/service/http_service.dart';

class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRouteState createState() {
    return _RegisterRouteState();
  }
}

class _RegisterRouteState extends State<RegisterRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _pwdController1 = TextEditingController();
  TextEditingController _pwdController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () async {
      // 检查服务器是否不更新
      HttpService httpService = HttpService();
      if(await httpService.checkNotUpdate()){
        return;
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
      print("register:later:$later");
      print("register:flag:$flag");
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: "注意", style: TextStyle(color: Colors.red)),
                    TextSpan(text: "该密码为APP终极密码，请一定牢记，一旦丢失将再也找不回"),
                  ]),
                ),
              ),
              TextFormField(
                controller: _pwdController1,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  return value.trim().isNotEmpty ? null : "密码不能为空";
                },
              ),
              TextFormField(
                controller: _pwdController2,
                decoration: InputDecoration(
                  labelText: "确认密码",
                  hintText: "请输入确认密码",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "确认密码不能为空";
                  }
                  if (_pwdController1.text.isNotEmpty &&
                      _pwdController1.text != value) {
                    return "两次密码不一致";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55),
                  child: RaisedButton(
                    onPressed: _register,
                    child: Text("进入"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _register() {
    if (_formKey.currentState.validate()) {
      Utils.showLoading(context, "正在进入...");
      try {
        Global.savePassword(_pwdController2.text);
      } catch (e) {
        print(e);
      } finally {
        // 关闭加载框
        Navigator.of(context).pop();
      }
      // 进入首页
      Navigator.of(context).pushReplacementNamed("MyHomePageRoute");
    }
  }
}
