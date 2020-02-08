import 'package:flutter/material.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/models/index.dart';
import 'package:password_manager/models/provider_model.dart';
import 'package:password_manager/service/pwd_manager_service.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
  }

  int id;

  @override
  Widget build(BuildContext context) {
    PwdManager pwdManager = ModalRoute.of(context).settings.arguments;
    bool isAdd = pwdManager == null;
    if (!isAdd) {
      // 此时页面是修改，输入框填充内容
      _titleController.text = pwdManager.title;
      _accountController.text = pwdManager.account;
      _passwordController.text = pwdManager.password;
      _titleController.selection = TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: _titleController.text.length));
      _accountController.selection = TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: _accountController.text.length));
      _passwordController.selection = TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: _passwordController.text.length));
      // 设置原有id
      id = pwdManager.id;
    }
    // 获取路由参数
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd ? "添加密码" : "修改密码"),
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
      try {
        pwdManager.title = _titleController.text;
        pwdManager.account = _accountController.text;
        pwdManager.password = _passwordController.text;
        if (id != null) {
          pwdManager.id = id;
          int updateId = await PwdManagerService.update(pwdManager);
        } else {
          int insertId = await PwdManagerService.insert(pwdManager);
        }
//        int id2 = await PwdManagerService.insert(pwdManager);
//        int id3 = await PwdManagerService.insert(pwdManager);
//        int id4 = await PwdManagerService.insert(pwdManager);
//        int id5 = await PwdManagerService.insert(pwdManager);
      } catch (e) {
        print(e);
      } finally {
        // 关闭加载弹窗
        Navigator.of(context).pop();
      }
      Provider.of<HomeRefreshModel>(context).homeRefresh = true;
//      Navigator.of(context).pop({"refresh":true});
      Navigator.of(context).pop(pwdManager);
//      List<PwdManager> list = await PwdManagerService.select(5, pageSize: 2);
//      print(list);
    }
  }
}
