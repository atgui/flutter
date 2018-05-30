import 'dart:async';
import 'package:flutter/material.dart';
import '../managers/manager.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_refresh/flutter_refresh.dart';

import '../models/VideoModel.dart';
import 'item/video_item.dart';

List<VideoModel> homeList=[];
class HomePage extends StatefulWidget {  
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _initBoo = false;

  //flutter_search_bar
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('首页推荐'),
        centerTitle: true,
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }

  _HomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted);
  }
  
  var pageIndex=0;

  @override
  void initState() {
    super.initState();
    // _init();
    if (homeList.length <= 0) {
      _getTopMovie();
    } else {
      setState(() {
        _initBoo = true;
      });
    }
  }

  _getTopMovie() async {
    pageIndex++;
    List<VideoModel> ms= await Manager.instance.getMovieTop(pageIndex);
    if (!mounted) return;
    if(ms.length>0){
      homeList.addAll(ms);
    }
    setState(() {
      _initBoo = true;
    });
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
      return VideoItem(
          key: Key('home_key'), mod: homeList[index]);
    }

    return Scaffold(
      // appBar: searchBar.build(context),//查询
      key: _scaffoldKey,
      body: Container(
          alignment: Alignment.topCenter,
          child: new Padding(
            padding: EdgeInsets.all(5.0),
            child: _initBoo == false
                ? const Center(
                    child: const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ))
                : new Refresh(//刷新
                    onFooterRefresh: onFooterRefresh,
                    onHeaderRefresh: null,
                    childBuilder: (BuildContext context,
                        {ScrollController controller, ScrollPhysics physics}) {
                      return new Container(
                          child: new ListView.builder(
                        physics: physics,
                        controller: controller,
                        itemBuilder: _itemBuilder,
                        itemCount: homeList.length,
                      ));
                    },
                  ),
          )),
    );
  }
}
