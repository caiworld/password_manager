import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  /// 弹出加载框
  static showLoading(BuildContext context,String msg) {
    showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text(msg),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 吐司
  static showToast(String msg) {
    print(msg);
    Fluttertoast.showToast(msg: msg);
  }
}
