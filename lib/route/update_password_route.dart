import 'package:flutter/material.dart';
import 'package:password_manager/service/pwd_manager_service.dart';

class UpdatePasswordRoute extends StatefulWidget {
  @override
  _UpdatePasswordRouteState createState() => _UpdatePasswordRouteState();
}

class _UpdatePasswordRouteState extends State<UpdatePasswordRoute> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _oldPwdController = TextEditingController();
  TextEditingController _newPwdController1 = TextEditingController();
  TextEditingController _newPwdController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改终极密码"),
      ),
      body: Center(
        child: Form(
          key: _globalKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _oldPwdController,
                decoration: InputDecoration(
                  labelText: "原密码",
                  hintText: "请输入原密码",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  return value.trim().isNotEmpty ? null : "原密码不能为空";
                },
              ),
              TextFormField(
                controller: _newPwdController1,
                decoration: InputDecoration(
                  labelText: "新密码",
                  hintText: "请输入新密码",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  return value.trim().isNotEmpty ? null : "新密码不能为空";
                },
              ),
              TextFormField(
                controller: _newPwdController2,
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
                  if (_newPwdController1.text.isNotEmpty &&
                      _newPwdController1.text != value) {
                    return "两次输入密码不一致";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: RaisedButton(
                  onPressed: () async {
                    if (_globalKey.currentState.validate()) {
                      // TODO 弹窗提醒
                      print("确认弹窗");
                      bool result = await PwdManagerService.updatePassword(
                          _oldPwdController.text, _newPwdController2.text);
                      print(result);
                      if (result) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("修改"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
