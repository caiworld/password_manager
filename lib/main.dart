import 'dart:async';
import 'dart:ffi';

import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/encrypt_decrypt_utils.dart';
import 'package:password_manager/models/index.dart';
import 'package:password_manager/models/provider_model.dart';
import 'package:password_manager/route/add_password_route.dart';
import 'package:password_manager/route/login_route.dart';
import 'package:password_manager/route/register_route.dart';
import 'package:password_manager/service/pwd_manager_service.dart';
import 'package:password_manager/widget/my_infinite_listview.dart';
import 'package:password_manager/widget/pwd_manager_item.dart';
import 'package:provider/provider.dart';

void main() {
  Global.init().then((e) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: HomeRefreshModel()),
      ],
      child: Consumer(
        builder: (BuildContext context, HomeRefreshModel homeRefreshModel,
            Widget child) {
          return MaterialApp(
            title: '密码管理器',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: _buildHome(),
            routes: <String, WidgetBuilder>{
              "AddPasswordRoute": (context) => AddPasswordRoute(),
              "MyHomePageRoute": (context) => MyHomePage(title: "密码管理器"),
              "LoginRoute": (context) => LoginRoute(),
            },
          );
        },
      ),
    );
  }

  Widget _buildHome() {
    if (Global.getPwdMd5().isNotEmpty) {
      return LoginRoute();
    } else {
      return RegisterRoute();
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed("AddPasswordRoute");
              })
        ],
      ),
      body: _buildBody(),
    );
  }

  List itemsCopy = [];

  GlobalKey<RefreshIndicatorState> _listKey =
      GlobalKey<RefreshIndicatorState>();

  List list = [];

  Widget _buildBody() {
    print("buildBody");
    bool result = Provider.of<HomeRefreshModel>(context).homeRefresh;
    print("result:$result");
    if (result) {
      _listKey.currentState.show();
      Provider.of<HomeRefreshModel>(context).homeRefresh = false;
    }
    if (list.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      key: _listKey,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (ctx, index) {
            //如果到了表尾
            if (list.length == index) {
              // 获取数据
              _retrieveData();
              if (_words.length - 1 < 100) {
                //加载时显示loading
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(strokeWidth: 2.0)),
                );
              } else {
                //已经加载了100条数据，不再获取数据。
                return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "没有更多了",
                      style: TextStyle(color: Colors.grey),
                    ));
              }
            }

            // 数据列表项
            return GestureDetector(
              child: PwdManagerItem(list[index]),
              onTap: () async {
//              Navigator.of(context)
//                  .pushNamed("AddPasswordRoute", arguments: list[index]);
                await _listKey.currentState.show();
              },
            );
          }),
      onRefresh: () async => await _getData(true),
    );
  }

  /// 下拉刷新获取数据 TODO 上拉加载获取数据
  Future<Null> _getData(bool refresh) async {
    final Completer<Null> completer = new Completer<Null>();
//
//    // 启动一下 [Timer] 在3秒后，在list里面添加一条数据，关完成这个刷新
//    new Timer(Duration(seconds: 3), () {
//      // 添加数据，更新界面
//      setState(() {
//        list.add("新加数据${list.length}");
//      });
//    });
    // 查询新数据
    List<PwdManager> data = await PwdManagerService.select(1, pageSize: 20);
    if (refresh) {
      list.clear();
    }
    setState(() {
      list.addAll(data);
    });
    // 完成刷新
    completer.complete(null);
    return completer.future;
  }

  _infiniteListView() {
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

  /// 生命周期方法
  @override
  void initState() {
    print("_MyHomePageRouteState:");
    print("initState");
    _getData(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO 使用真机验证生命周期
    switch (state) {
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive');
        break;
      case AppLifecycleState.paused:
        print('AppLifecycleState.paused');
        break;
      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed');
        break;
      case AppLifecycleState.suspending:
        print('AppLifecycleState.suspending');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
