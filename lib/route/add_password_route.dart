import 'package:flutter/material.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/models/index.dart';
import 'package:password_manager/service/pwd_manager_service.dart';

/// 添加密码页面
class AddPasswordRoute extends StatefulWidget {
  @override
  _AddPasswordRouteState createState() {
    return _AddPasswordRouteState();
  }
}

class _AddPasswordRouteState extends State<AddPasswordRoute> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _accountController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加密码"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        // 自动校验
        autovalidate: false,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "标题",
                hintText: "请输入标题",
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                return value.trim().isNotEmpty ? null : "标题不能为空";
              },
            ),
            TextFormField(
              controller: _accountController,
              decoration: InputDecoration(
                labelText: "账号",
                hintText: "请输入账号",
                prefixIcon: Icon(Icons.account_circle),
              ),
              validator: (value) {
                return value.trim().isNotEmpty ? null : "账号不能为空";
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock)),
              validator: (value) {
                return value.trim().isNotEmpty ? null : "密码不能为空";
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: RaisedButton(
                onPressed: _save,
                child: Text("保存"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 保存
  _save() async {
    // 保存之前先进行校验各个表单字段是否合法
    if (_formKey.currentState.validate()) {
      // 该方法表示当所有表单都通过时会返回true
      Utils.showLoading(context, "正在加密保存");
      PwdManager pwdManager = new PwdManager();
      pwdManager.title = "工商银行";
      pwdManager.account = "ICBC";
      pwdManager.password = "123456";
      print("pwdManager.id:${pwdManager.id}");
      int i = await PwdManagerService.insert(pwdManager);
      print(i);
      List<Map<String, dynamic>> list = await PwdManagerService.select();
      print(list);
      // 关闭加载弹窗
      Navigator.of(context).pop();
    }
  }
}
