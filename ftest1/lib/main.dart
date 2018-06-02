

import 'dart:async';

//import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './managers/manager.dart';
import './managers/system_manager.dart';
import './page/home_page.dart';
import './page/hot_page.dart';
import './page/type_page.dart';
import './page/me_page.dart';
//import 'package:video_player/video_player.dart';

void main() {
  try {
    runApp(
      new MyApp(),
//  new ChewieDemo(),
    );
  } catch (e, s) {
    print(s);
  }
}

class MyApp extends StatelessWidget {
  var s=SystemManager.systemOs();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        platform: s=="IOS"?TargetPlatform.iOS:TargetPlatform.android
      ),
      home: RunApp(),
    );
  }
}


class RunApp extends StatefulWidget {
  @override
  _RunAppState createState() => new _RunAppState();
}

class _RunAppState extends State<RunApp> {
  bool isRun=false;
//  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
//    _controller = new VideoPlayerController.asset(
//      'assets/tvideo.mp4',
//    );
//    _controller.setVolume(1.0);

    new Timer(Duration(seconds: 3),(){
      isRun=true;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

//    final fullView=new Container(
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height,
//      child: new Center(
//        child:new Chewie(
//          _controller,
//          aspectRatio: 3 / 2,
//          autoPlay: false,
//          looping: false,
//          showControls: true,
//
//          // Try playing around with some of these other options:
//
//          // showControls: false,
//          // materialProgressColors: new ChewieProgressColors(
//          //   playedColor: Colors.red,
//          //   handleColor: Colors.blue,
//          //   backgroundColor: Colors.grey,
//          //   bufferedColor: Colors.lightGreen,
//          // ),
//          // placeholder: new Container(
//          //   color: Colors.grey,
//          // ),
//          // autoInitialize: true,
//        ),
//      ),
//    );

    return
//      new Scaffold(
//      appBar: new AppBar(
//        title: Text("测试"),
//        backgroundColor: Colors.blue,
//      ),
//      body: fullView,
//    );
      isRun==false?Scaffold(
      body: Container(
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset("assets/init.jpg",fit: BoxFit.fill,),
        ),
      ),
    ):MainView();
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
//    await _getServer();
//    print("getserver over...");
    await _getToken();
//    await _getVersion();
//    await _getSpeedTestSetting();
//    await _getCdn();
    setState(() {
      isToken = true;
    });
  }

  _getServer() async{
    var boo=await Manager.instance.getServer();
    if(boo==false){
      SystemManager.showLog("获取API", "获取API失败");
    }
  }
  _getToken() async {
    var boo = await Manager.instance.getToken();
    if (boo == false) {
      SystemManager.showLog("获取TOKEN",'获取TOKEN失败!!!');
    }
  }
  _getVersion() async {
//    var boo = await Manager.instance.getVersion();
//    if (boo == false) {
//      SystemManager.showLog("获取版本号",'获取版本失败');
//    }
  }
  _getSpeedTestSetting() async{
//    var boo=await Manager.instance.getspeedtestsetting();
//    if (boo == false) {
//      SystemManager.showLog("", "获取SpeedTestSetting失败!!!");
//    }
  }
  _getCdn() async{
//    var boo=await Manager.instance.getCdn();
//    if (boo == false) {
//      SystemManager.showLog("获取CDN资源", "获取CDN资源失败!!!");
//    }
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