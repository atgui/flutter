import 'dart:async';
import 'package:flutter/material.dart';
import '../models/videomodel.dart';
import '../managers/manager.dart';
import './common/Common.dart';

List<VideoModel> newMovieList1 = [];
var newPageIndex1 = 0;

List<VideoModel> newMovieList = [];
var newPageIndex = 0;

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

class HotNewsPage extends StatefulWidget {
  @override
  _HotNewsPageState createState() => new _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  var _initBoo = false;
  CommonRefresh _commonRefresh;

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
    _commonRefresh = new CommonRefresh();
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
    return _initBoo == false
        ? const Center(
            child: const CircularProgressIndicator(
            backgroundColor: Colors.white,
          ))
        : _commonRefresh.getContext(
            newMovieList, onFooterRefresh, onHeaderRefresh);
  }
}

class HotNewsPage1 extends StatefulWidget {
  @override
  _HotNewsPageState1 createState() => new _HotNewsPageState1();
}

class _HotNewsPageState1 extends State<HotNewsPage1> {
  CommonRefresh _commonRefresh;
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
    _commonRefresh = new CommonRefresh();
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
    return _initBoo == false
        ? const Center(
            child: const CircularProgressIndicator(
            backgroundColor: Colors.white,
          ))
        : _commonRefresh.getContext(
            newMovieList1, onFooterRefresh, onHeaderRefresh);
  }
}
