import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/pwdManager.dart';
import 'package:password_manager/service/pwd_manager_service.dart';
import 'package:password_manager/widget/pwd_manager_item.dart';

class MyInfiniteListView extends StatefulWidget {
  @override
  _MyInfiniteListViewState createState() {
    return _MyInfiniteListViewState();
  }
}

class _MyInfiniteListViewState extends State<MyInfiniteListView> {
  @override
  Widget build(BuildContext context) {
    return InfiniteListView<PwdManager>(
      onRetrieveData: (int page, List<PwdManager> items, bool refresh) async {
        // TODO refresh 还没用上
        // 查询新数据
        List<PwdManager> data =
            await PwdManagerService.select(page, pageSize: 20);
        // 将新查出来的数据添加到原有集合
        items.addAll(data);
        return data.length == 20;
      },
      itemBuilder: (List<PwdManager> list, int index, BuildContext ctx) {
        // 数据列表项
        return GestureDetector(
          child: PwdManagerItem(list[index]),
          onTap: () {
            Navigator.of(context)
                .pushNamed("AddPasswordRoute", arguments: list[index]);
          },
        );
      },
    );
  }
}
