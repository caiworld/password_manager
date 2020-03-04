import 'dart:async';

import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:password_manager/common/Global.dart';
import 'package:password_manager/common/utils.dart';
import 'package:password_manager/i10n/localization_intl.dart';
import 'package:password_manager/models/index.dart';
import 'package:password_manager/models/provider_model.dart';
import 'package:password_manager/route/account_manager_route.dart';
import 'package:password_manager/route/add_password_route.dart';
import 'package:password_manager/route/language_route.dart';
import 'package:password_manager/route/login_route.dart';
import 'package:password_manager/route/register_route.dart';
import 'package:password_manager/route/restore_password_route.dart';
import 'package:password_manager/route/theme_change_route.dart';
import 'package:password_manager/route/update_password_route.dart';
import 'package:password_manager/service/pwd_manager_service.dart';
import 'package:password_manager/service/service_locator.dart';
import 'package:password_manager/widget/loading_view.dart';
import 'package:password_manager/widget/my_drawer.dart';
import 'package:password_manager/widget/pwd_manager_item.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:password_manager/common/check.dart';

void main() {
  setupLocator();
  Global.init().then((e) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: HomeRefreshModel()),
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),// 1
      ],
      child: Consumer2(
        builder: (BuildContext context, HomeRefreshModel homeRefreshModel,
            LocaleModel localeModel, Widget child) {
          return MaterialApp(
            localizationsDelegates: [// 2
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              MyLocalizationsDelegate(),
            ],
            locale:localeModel.getLocale(),// 3
            onGenerateTitle: (context) {// 4
              // 此时context在Localizations的子树中，以避免MaterialApp中的title属性报错
              return MyLocalizations.of(context).title;
            },
            supportedLocales: [ // 5
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
            ],
            // 6
            localeResolutionCallback: (Locale _locale, Iterable<Locale> supportedLocales){
              if(localeModel.getLocale()!=null){
                // 表名已经选定语言，则不跟随系统
                return localeModel.getLocale();
              }else{
               Locale locale;
               // app语言跟随系统语言，如果系统语言不是中文简体或美国英语，
               // 则默认使用中文
                if(supportedLocales.contains(_locale)){
                  locale = _locale;
                }else{
                  locale = Locale('zh','CN');
                }
                return locale;
              }
            },
            debugShowCheckedModeBanner: false,
//            title: '密码管理器',
            theme: ThemeData(
                primarySwatch: Provider.of<ThemeModel>(context).theme),
            home: _buildHome(),
            routes: <String, WidgetBuilder>{
              "AddPasswordRoute": (context) => AddPasswordRoute(),
              "MyHomePageRoute": (context) => MyHomePage(title: "密码管理器"),
              "LoginRoute": (context) => LoginRoute(),
              "UpdatePasswordRoute": (context) => UpdatePasswordRoute(),
              "AccountManagerRoute": (context) => AccountManagerRoute(),
              "RestorePasswordRoute": (context) => RestorePasswordRoute(),
              "ThemeChangeRoute": (context) => ThemeChangeRoute(),
              "LanguageRoute": (context) => LanguageRoute(),
            },
          );
        },
      ),
    );
  }

  Widget _buildHome() {
    if (Global.getPwdMd5() != null && Global.getPwdMd5().isNotEmpty) {
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
                Navigator.of(context)
                    .pushNamed("AddPasswordRoute")
                    .then((pwdManagerModel) {
                  if (pwdManagerModel != null) {
                    setState(() {
                      data.insert(0, pwdManagerModel);
                    });
                  }
                });
              })
        ],
      ),
      body: _buildBody(),
      drawer: MyDrawer(),
    );
  }

//  final GlobalKey<RefreshIndicatorState> _listKey =
//      GlobalKey<RefreshIndicatorState>();

  List list = [];

  Widget _buildBody() {
    print("buildBody");
//    bool result = Provider.of<HomeRefreshModel>(context).homeRefresh;
//    print("result:$result");
//    if (result) {
//      Provider.of<HomeRefreshModel>(context).homeRefresh = false;
//      _listKey.currentState.show();
//      setState(() async {
//        await _getData(true);
//      });
//    }

//    if (list.length == 0) {
//      return Center(
//        child: CircularProgressIndicator(),
//      );
//    }
    // TODO start -- 这部分代码删掉
//    return RefreshIndicator(
//      key: _listKey,
//      child: ListView.builder(
//          physics: const AlwaysScrollableScrollPhysics(),
//          itemCount: list.length,
//          itemBuilder: (ctx, index) {
//            print("${list.length}; $index");
//            //如果到了表尾
//            if (list.length - 1 == index) {
//              // 加载数据
//              _getData(false);
//              if (list.length - 1 < 100) {
//                //加载时显示loading
//                return Container(
//                  padding: const EdgeInsets.all(16.0),
//                  alignment: Alignment.center,
//                  child: SizedBox(
//                      width: 24.0,
//                      height: 24.0,
//                      child: CircularProgressIndicator(strokeWidth: 2.0)),
//                );
//              } else {
//                //已经加载了100条数据，不再获取数据。
//                return Container(
//                    alignment: Alignment.center,
//                    padding: EdgeInsets.all(16.0),
//                    child: Text(
//                      "没有更多了",
//                      style: TextStyle(color: Colors.grey),
//                    ));
//              }
//            }
//
//            // 数据列表项
//            return GestureDetector(
//              child: PwdManagerItem(list[index]),
//              onTap: () async {
////              Navigator.of(context)
////                  .pushNamed("AddPasswordRoute", arguments: list[index]);
//                await _listKey.currentState.show();
//              },
//            );
//          }),
//      onRefresh: () async => await _getData(true),
//    );
    // TODO end -- 这部分代码删掉
    // InfiniteListView这个ListView不好，因为不方便在外部修改item的内容
//    return _infiniteListView();

    return _listView();
  }

  List data = List();

  // 是否请求了，没请求好之前显示加载中
  bool isReq = false;

  Widget _listView() {
    return RefreshConfiguration(
      hideFooterWhenNotFull: true,
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refreshData,
        onLoading: _loadData,
        enablePullUp: true,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: isReq
            ? listNotEmpty(data)
                ? ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: PwdManagerItem(data[index]),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("AddPasswordRoute",
                                  arguments: data[index])
                              .then((pwdManagerModel) {
                            data[index] = pwdManagerModel;
                          });
                        },
                      );
                    })
                : Center(
                    child: Text(
                      "暂无数据",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  )
            : LoadingView(),
      ),
    );
  }

  /// 刷新数据
  Future<void> _refreshData() async {
    Completer completer = new Completer();

    // 将原来数据清空
    data = [];
    _getData();

    Future.delayed(Duration(seconds: 2), () {
      completer.complete(null);
      _refreshController.refreshCompleted();
    });

    return completer.future;
  }

// TODO 可以提取到 common 中
  static const int _pageSize = 8;

  /// 加载数据
  _loadData() {
    print("loadData");
    Completer completer = new Completer();

    if (data.length == (data.length / _pageSize).ceil() * _pageSize) {
      _getData(
          page: ((data.length + 1) / _pageSize).ceil(), pageSize: _pageSize);
    } else {
      _refreshController.footerMode = ValueNotifier(LoadStatus.noMore);
      setState(() {});
    }
    Future.delayed(Duration(seconds: 2), () {
      completer.complete(null);
      _refreshController.loadComplete();
    });
    return completer.future;
  }

  _getData({int page = 1, int pageSize = _pageSize}) {
    PwdManagerService.select(page, pageSize: pageSize).then((result) {
//      if (mounted) {
      setState(() {
        // 这里好像没有起作用
        if (page > 1 && result.length < pageSize) {
          _refreshController.footerMode = ValueNotifier(LoadStatus.noMore);
        }
        data.addAll(result);
        isReq = true;
      });
//      }
    });
  }

  /// 下拉刷新获取数据 TODO 上拉加载获取数据
//  Future<Null> _getData(bool refresh) async {
//    final Completer<Null> completer = new Completer<Null>();
//    // 查询新数据
//    List<PwdManager> data;
//    if (refresh) {
//      // 刷新
//      data = await PwdManagerService.select(1, pageSize: 12);
//      list.clear();
//    } else {
//      // 加载
//      data = await PwdManagerService.select(((list.length + 1) / 12).ceil(),
//          pageSize: 12);
//    }
//    setState(() {
//      list.addAll(data);
//    });
//    // 完成刷新
//    completer.complete(null);
//    return completer.future;
//  }

// TODO 最重要
//  另外当一个密码都没有的时候，添加完成的时候首页不显示出来数据
  // 另外修改数据后显示的是加密的密码
// TODO 刷新和加载还是使用 InfiniteListView，然后修改后通过页面传输数据修改当前数据
  // TODO 然后就是需要做侧边栏了
  _infiniteListView() {
    return InfiniteListView<PwdManager>(
      onRetrieveData: (int page, List<PwdManager> items, bool refresh) async {
        // TODO refresh 还没用上
        print("refresh:$refresh");
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
                .pushNamed("AddPasswordRoute", arguments: list[index])
                .then((pwdManagerModel) {
              list[index] = pwdManagerModel;
            });
          },
        );
      },
    );
  }

  /// 生命周期方法
  @override
  void initState() {
    super.initState();
    print("_MyHomePageRouteState:");
    print("initState");
//    _getData(true);
    _getData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    // TODO 如果导入数据后想刷新首页，可以让导入数据页面返回到首页，并给出一个标记
    // 然后在此处进行刷新页面
//    _refreshData();
    print("deactivate");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    Utils.showToast("退出");
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("生命周期：${state.toString()}");
    // TODO 探索生命周期，学习在软件进入后台时清除密码 ? springboot + 邮件服务
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
