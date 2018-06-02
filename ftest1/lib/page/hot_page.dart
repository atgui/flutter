import 'dart:async';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:flutter/material.dart';
import '../models/videomodel.dart';
import './details/detail_page.dart';
import '../managers/manager.dart';

class HotPage extends StatefulWidget {
  @override
  _HotPageState createState() => new _HotPageState();
}

class _HotPageState extends State<HotPage> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    var _appBar = AppBar(
      leading: Text(""),
      actions: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width - 5,
            child: Material(
              animationDuration: kThemeAnimationDuration,
              shadowColor: Colors.black,
              child: TabBar(
                labelColor: Colors.black54,
                unselectedLabelColor: Colors.black54,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "热门",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                      child: Text(
                        "最新",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ))
      ],
      backgroundColor: Colors.white,
    );
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar,
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          HotNewsPage(),
          HotNewsPage1(),
        ],
      ),
    );
  }
}

List<VideoModel> newMovieList = [];
var newPageIndex = 0;

class HotNewsPage extends StatefulWidget {
  @override
  _HotNewsPageState createState() => new _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  var _initBoo = false;

  _getTopMovie() async {
    newPageIndex++;
    List<VideoModel> ms = await Manager.instance.getMoveMode(1, newPageIndex);
    if (!mounted) return;
    if (ms.length > 0) {
      newMovieList.addAll(ms);
    }
    setState(() {
      _initBoo = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (newMovieList.length <= 0) {
      _getTopMovie();
    } else {
      setState(() {
        _initBoo = true;
      });
    }
  }

  Future<Null> onFooterRefresh() async {
    await _getTopMovie();
    return null;
  }

  Future<Null> onHeaderRefresh() {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _touchToDetailPage(VideoModel mod){
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (context)=>new DetailPage(mod:mod,key: Key("to_detail_key"),))
      );
    }


    Widget _itemBuilder(BuildContext context, int index) {
      return new Card(
        elevation: 10.0,
        child: new Padding(
          padding: EdgeInsets.all(5.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new GestureDetector(
                onTap: (){
                  print("到播放页面");
                  _touchToDetailPage(newMovieList[index]);
                },
                child: new FadeInImage(
                  placeholder: AssetImage(
                      "assets/load.gif"), //new Image(image: Image.asset(""),).image,
                  image: new NetworkImage(
                      "${Manager.instance.resUrl}${newMovieList[index].cover}"), //AssetImage('assets/test.jpg'),//
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0,right: 10.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new CircleAvatar(
                    foregroundColor: Colors.greenAccent,
                    backgroundImage: NetworkImage(
                        "${Manager.instance.resUrl}${newMovieList[index].avatar}"), //AssetImage('assets/head.jpg'),new AssetImage('assets/head.jpg'),//
                    radius: 30.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print("点击标题");
                          _touchToDetailPage(newMovieList[index]);
                        },
                        child: Container(
                          width: 150.0,
                          alignment: Alignment.center,
                          child: Text(
                            newMovieList[index].title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.date_range),
                          Text(newMovieList[index].getDate()),
                          Text("|",style: TextStyle(fontSize: 20.0),),
                          Icon(Icons.timer),
                          Text(newMovieList[index].getTime())
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    return _initBoo == false
        ? const Center(
        child: const CircularProgressIndicator(
          backgroundColor: Colors.white,
        ))
        : Refresh(
      //刷新
      onFooterRefresh: onFooterRefresh,
      onHeaderRefresh: null,
      childBuilder: (BuildContext context,
          {ScrollController controller, ScrollPhysics physics}) {
        return new Container(
            child: new ListView.builder(
              physics: physics,
              controller: controller,
              itemBuilder: _itemBuilder,
              itemCount: newMovieList.length,
            ));
      },
    );
  }
}

List<VideoModel> newMovieList1 = [];
var newPageIndex1 = 0;

class HotNewsPage1 extends StatefulWidget {
  @override
  _HotNewsPageState1 createState() => new _HotNewsPageState1();
}

class _HotNewsPageState1 extends State<HotNewsPage1> {

  var _initBoo = false;
  _getTopMovie() async {
    newPageIndex1++;
    List<VideoModel> ms = await Manager.instance.getMoveMode(2, newPageIndex1);
    if (!mounted) return;
    if (ms.length > 0) {
      newMovieList1.addAll(ms);
    }
    setState(() {
      _initBoo = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (newMovieList1.length <= 0) {
      _getTopMovie();
    } else {
      setState(() {
        _initBoo = true;
      });
    }
  }

  Future<Null> onFooterRefresh() async {
    await _getTopMovie();
    return null;
  }

  Future<Null> onHeaderRefresh() {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _touchToDetailPage(VideoModel mod){
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (context)=>new DetailPage(mod:mod,key: Key("to_detail_key"),))
      );
    }


    Widget _itemBuilder(BuildContext context, int index) {
      return new Card(
        elevation: 10.0,
        child: new Padding(
          padding: EdgeInsets.all(5.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new GestureDetector(
                onTap: (){
                  print("到播放页面");
                  _touchToDetailPage(newMovieList1[index]);
                },
                child: new FadeInImage(
                  placeholder: AssetImage(
                      "assets/load.gif"), //new Image(image: Image.asset(""),).image,
                  image: new NetworkImage(
                      "${Manager.instance.resUrl}${newMovieList1[index].cover}"), //AssetImage('assets/test.jpg'),//
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0,right: 10.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new CircleAvatar(
                    foregroundColor: Colors.greenAccent,
                    backgroundImage: NetworkImage(
                        "${Manager.instance.resUrl}${newMovieList1[index].avatar}"), //AssetImage('assets/head.jpg'),new AssetImage('assets/head.jpg'),//
                    radius: 30.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print("点击标题");
                          _touchToDetailPage(newMovieList1[index]);
                        },
                        child: Container(
                          width: 150.0,
                          alignment: Alignment.center,
                          child: Text(
                            newMovieList1[index].title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.date_range),
                          Text(newMovieList1[index].getDate()),
                          Text("|",style: TextStyle(fontSize: 20.0),),
                          Icon(Icons.timer),
                          Text(newMovieList1[index].getTime())
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    return _initBoo == false
        ? const Center(
        child: const CircularProgressIndicator(
          backgroundColor: Colors.white,
        ))
        : Refresh(
      //刷新
      onFooterRefresh: onFooterRefresh,
      onHeaderRefresh: null,
      childBuilder: (BuildContext context,
          {ScrollController controller, ScrollPhysics physics}) {
        return new Container(
            child: new ListView.builder(
              physics: physics,
              controller: controller,
              itemBuilder: _itemBuilder,
              itemCount: newMovieList1.length,
            ));
      },
    );
  }
}
