import 'package:flutter/material.dart';

class HomeRefreshModel extends ChangeNotifier {
  bool homeRefresh = false;

  bool get refresh => homeRefresh;

  set refresh(bool homeRefresh) {
    homeRefresh = homeRefresh;
    notifyListeners();
  }

}
