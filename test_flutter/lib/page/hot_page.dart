import 'dart:async';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:flutter/material.dart';
import '../managers/manager.dart';
import '../models/VideoModel.dart';
import './item/video_item.dart';

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

class HotNewsPage extends StatefulWidget {
  @override
  _HotNewsPageState createState() => new _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  var _initBoo = false;
  var pageIndex = 0;
  _getTopMovie() async {
    pageIndex++;
    List<VideoModel> ms = await Manager.instance.getMoveMode(1, pageIndex);
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
    Widget _itemBuilder(BuildContext context, int index) {
      return VideoItem(key: Key('home_key'), mod: newMovieList[index]);
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

class HotNewsPage1 extends StatefulWidget {
  @override
  _HotNewsPageState1 createState() => new _HotNewsPageState1();
}

class _HotNewsPageState1 extends State<HotNewsPage1> {
  var pageIndex = 0;
  var _initBoo = false;
  _getTopMovie() async {
    pageIndex++;
    List<VideoModel> ms = await Manager.instance.getMoveMode(2, pageIndex);
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
    Widget _itemBuilder(BuildContext context, int index) {
      return VideoItem(key: Key('home_key'), mod: newMovieList1[index]);
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
