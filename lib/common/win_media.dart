import 'package:flutter/material.dart';

/// 获取屏幕宽度
double winWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

/// 获取屏幕高度
double winHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
