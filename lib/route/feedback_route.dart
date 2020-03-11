import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/service/http_service.dart';
import 'package:password_manager/widget/jh_photo_picker_tool_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/src/media_type.dart';

class FeedbackRoute extends StatefulWidget {
  @override
  _FeedbackRouteState createState() => _FeedbackRouteState();
}

class _FeedbackRouteState extends State<FeedbackRoute> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _textController = TextEditingController();

  List<String> imgPaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("意见反馈"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendFeedback,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
        child: SingleChildScrollView(
          child: Form(
            key: _globalKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  maxLines: 5,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "反馈内容",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    return value.trim().isNotEmpty ? null : "请输入反馈内容";
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: JhPhotoPickerTool(
                      lfPaddingSpace: 0,
                      callBack: (var img) {
                        print("img-------------");
                        print(img.length);
                        print(img);
                        imgPaths = [];
                        imgPaths.addAll(img.cast());
                        print("img-------------");
                      }),
                ),
//                RaisedButton(
//                  onPressed: _sendFeedback,
//                  child: Text("发送"),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 发送多张图片
  _sendFeedback() async {
    // 校验
    if (_globalKey.currentState.validate()) {}
    List<MultipartFile> files = [];
    for (int i = 0; i < imgPaths.length; i++) {
      String path = imgPaths[i];
      print(path);
      MultipartFile file = await MultipartFile.fromFile(
        path,
        filename: path.substring(path.lastIndexOf("/") + 1),
        contentType: MediaType(
          "image",
          path.substring(path.lastIndexOf(".") + 1),
        ),
      );
      files.add(file);
    }
    String content = "from：" +
            (Global.getBySharedPreferences("account") ?? "") +
            "<br>content：" +
            _textController.text ??
        "";
    FormData formData = FormData.fromMap({"files": files, "content": content});
    Map<String, dynamic> map = Map<String, dynamic>();
    map["files"] = files;
    map["content"] = content;
    Utils.showToast("正在发送反馈中");
    Map result = await HttpService().sendFeedback(formData, map);
    if(result != null && result['success']){
      Utils.showToast("反馈成功");
      Navigator.of(context).pop();
    }else{
      Utils.showToast("反馈失败，请稍候重试");
    }
  }

  /// 发送单张图片
  _sendFeedback2() async {
    // 校验
    if (_globalKey.currentState.validate()) {}
    String path = imgPaths[0];
    print(path);
    MultipartFile file = await MultipartFile.fromFile(
      path,
      filename: path.substring(path.lastIndexOf("/") + 1),
      contentType: MediaType(
        "image",
        path.substring(path.lastIndexOf(".") + 1),
      ),
    );
    FormData formData = FormData.fromMap({
      "file": file,
      "content": _textController.text ?? "",
      "from": Global.getBySharedPreferences("account") ?? ""
    });
    HttpService().sendFeedback(formData, null);
    Utils.showToast("发送反馈");
  }
}
