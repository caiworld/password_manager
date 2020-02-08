import 'package:flutter/material.dart';
import 'package:password_manager/common/win_media.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: winWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Container(
            width: 10,
            height: 10,
          ),
          Text(
            "加载中",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
