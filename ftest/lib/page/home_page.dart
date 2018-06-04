import 'dart:async';
import 'package:flutter/material.dart';
import './common/Common.dart';
import '../managers/manager.dart';
import '../models/videomodel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

var pageIndex = 0;
List<VideoModel> homeList = [];

class _HomePageState extends State<HomePage> {
  var _initBoo = false; //是否加载好数据
  CommonRefresh _commonRefresh;

  _getTopMovie() async {
    pageIndex++;
    List<VideoModel> ms = await Manager.instance.getMovieTop(pageIndex);
    if (!mounted) return;
    if (ms.length > 0) {
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
  void initState() {
    super.initState();
    _commonRefresh = new CommonRefresh();

    if (homeList.length <= 0) {
      _getTopMovie();
    } else {
      setState(() {
        _initBoo = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.topCenter,
          child: new Padding(
            padding: EdgeInsets.all(0.0),
            child: _initBoo == false
                ? const Center(
                    child: const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ))
                : _commonRefresh.getContext(
                    homeList, onFooterRefresh, onHeaderRefresh),
          )),
    );
  }
}
