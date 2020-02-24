import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/models/index.dart';
import 'package:password_manager/service/pwd_manager_service.dart';

/// 解析导入密码页面
class RestorePasswordRoute extends StatefulWidget {
  @override
  _RestorePasswordRouteState createState() => _RestorePasswordRouteState();
}

class _RestorePasswordRouteState extends State<RestorePasswordRoute> {
  // json数据controller
  TextEditingController _controller = TextEditingController();

  // 终极密码controller
  TextEditingController _pwdController = TextEditingController();

  // 是否显示密码
  bool _pwdHidden = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("恢复密码"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "请输入要被解析并导入的json数据",
                  border: OutlineInputBorder(),
                ),
                // TODO 输入框长按显示的是英文，待解决
                maxLines: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                    hintText: "请输入对应的终极密码",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        icon: Icon(_pwdHidden
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _pwdHidden = !_pwdHidden;
                          });
                        }),
                  ),
                  obscureText: _pwdHidden,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_controller.text == null ||
                          _controller.text.isEmpty) {
                        Utils.showToast("请输入要被解析并导入的json数据");
                        return;
                      }
                      if (_pwdController.text == null ||
                          _pwdController.text.isEmpty) {
                        Utils.showToast("请输入对应的终极密码");
                        return;
                      }
                      // 解析
//                      List<Map<String, dynamic>> list =
//                          (json.decode(_controller.text)
//                                  as List<Map<String, dynamic>>)
//                              .cast();
                      List list = json.decode(_controller.text);
                      List<PwdManager> result = List<PwdManager>();
                      // 将原终极密码进行千次md5
                      String oldPwdMd5 =
                          EncryptDecryptUtils.md5Thousand(_pwdController.text);
                      String newPwdMd5 = Global.getPwdMd5();
                      for (var item in list) {
                        PwdManager oldPwd = PwdManager.fromJson(item);
                        String decryptPasswordStr =
                            await EncryptDecryptUtils.decrypt(
                                oldPwdMd5, oldPwd);
                        if (decryptPasswordStr == null) {
                          break;
                        }
                        // 重新加密
                        PwdManager encryptPwdManager =
                            await EncryptDecryptUtils.encrypt(
                                newPwdMd5, decryptPasswordStr);
                        oldPwd.id = null;
                        oldPwd.password = encryptPwdManager.password;
                        oldPwd.salt = encryptPwdManager.salt;
                        oldPwd.updateTime = DateTime.now().toString();
                        result.add(oldPwd);
                      }
                      if (result.length != list.length) {
                        // 说明解密失败，可能是终极密码不对
                        Utils.showToast("解析失败");
                        return;
                      }
                      // 导入
                      bool success =
                          await PwdManagerService.addPwdManagerList(result);
                      print("导入:$success");
                      // 导入成功
                      if(success){
                        Utils.showToast("导入成功");
                        // TODO 发送密码到邮箱

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("解析并导入"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
