import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/main.dart';

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

  @override
  Widget build(BuildContext context) {
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
}
