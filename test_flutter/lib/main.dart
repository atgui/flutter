import 'dart:async';
import 'package:flutter/material.dart';
import './page/home_page.dart';
import './page/hot_page.dart';
import './page/me_page.dart';
import './page/type_page.dart';
import 'managers/SystemManager.dart';
import 'managers/manager.dart';

void main() {
  print("开始启动");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  //   VideoDetailPage.TAG: (context) => VideoDetailPage()
  // };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: RunPage(),
      // routes: routes,
    );
  }
}

class RunPage extends StatefulWidget {
  @override
  _RunPageState createState() => new _RunPageState();
}

class _RunPageState extends State<RunPage> {
  var isRun = false;
  _start() {
    Timer timer;
    timer = new Timer(Duration(seconds: 5), () {
      setState(() {
        isRun = true;
        timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return isRun == false
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset("assets/splash_bg.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill),
          )
        : MainView();
  }
}

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => new _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  var isToken = false;

  List<Tab> bottomLists = [
    Tab(icon: Icon(Icons.home)),
    Tab(icon: Icon(Icons.hot_tub)),
    Tab(icon: Icon(Icons.merge_type)),
    Tab(icon: Icon(Icons.my_location)),
  ];

  List<Widget> tabs = [
    new Tab(
      // text: "首页",
      icon: new Icon(
        Icons.home,
      ),
    ),
    new Tab(
      // text: "热门",
      icon: new Icon(
        Icons.hot_tub,
      ),
    ),
    new Tab(
      // text: "类型",
      icon: new Icon(
        Icons.apps,
      ),
    ),
    new Tab(
      // text: "我",
      icon: new Icon(
        Icons.account_box,
      ),
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    tabController = new TabController(
        vsync: this, length: bottomLists.length, initialIndex: 0);
  }

  _init() async {
    await _getToken();
    await _getVersion();
    await _getSpeedTestSetting();
    await _getCdn();
    setState(() {
      isToken = true;
    });
  }

  _getToken() async {
    var boo = await Manager.instance.getToken();
    if (boo == false) {
      SystemManager.showLog("获取TOKEN",'获取TOKEN失败!!!');
    }
  }
  _getVersion() async {
    var boo = await Manager.instance.getVersion();
    if (boo == false) {
      SystemManager.showLog("获取版本号",'获取版本失败');
    }
  }
  _getSpeedTestSetting() async{
    var boo=await Manager.instance.getspeedtestsetting();
    if (boo == false) {
      SystemManager.showLog("", "获取SpeedTestSetting失败!!!");
    }
  }
  _getCdn() async{
    var boo=await Manager.instance.getCdn();
    if (boo == false) {
      SystemManager.showLog("获取CDN资源", "获取CDN资源失败!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new Material(
        animationDuration: Duration(milliseconds: 200),
        color: Colors.white,
        child: new TabBar(
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black45,
          controller: tabController,
          tabs: tabs,
        ),
      ),
      body: isToken == true
          ? Material(
            animationDuration:kThemeAnimationDuration,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                HomePage(),
                HotPage(),
                TypePage(),
                MePage(),
              ],
            ),
          )
          : Container(),
    );
  }
}
