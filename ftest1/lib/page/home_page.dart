import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import '../managers/manager.dart';
import '../models/videomodel.dart';
import './details/detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

var pageIndex = 0;
List<VideoModel> homeList = [];

class _HomePageState extends State<HomePage> {
  var _initBoo = false; //是否加载好数据

  _getTopMovie() async {
    pageIndex++;
    print("请求影片数据");
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
    // TODO: implement initState
    super.initState();
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
    _touchToDetailPage(VideoModel mod) {
      Navigator.push(context,new MaterialPageRoute(
          builder: (context) => new DetailPage(
            mod: mod,
            key: Key("to_detail_key"),
          )));
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
                onTap: () {
                  print("到播放页面");
                  _touchToDetailPage(homeList[index]);
                },
                child: new FadeInImage(
                  placeholder: AssetImage(
                      "assets/load.gif"), //new Image(image: Image.asset(""),).image,
                  image: new NetworkImage(
                      "${Manager.instance.resUrl}${homeList[index].cover}"), //AssetImage('assets/test.jpg'),//
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 10.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new CircleAvatar(
                    foregroundColor: Colors.greenAccent,
                    backgroundImage: NetworkImage(
                        "${Manager.instance.resUrl}${homeList[index].avatar}"), //AssetImage('assets/head.jpg'),new AssetImage('assets/head.jpg'),//
                    radius: 30.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print("点击标题");
                          _touchToDetailPage(homeList[index]);
                        },
                        child: Container(
                          width: 150.0,
                          alignment: Alignment.center,
                          child: Text(
                            homeList[index].title,
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
                          Text(homeList[index].getDate()),
                          Text(
                            "|",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Icon(Icons.timer),
                          Text(homeList[index].getTime()),
                          IconButton(
                            icon: homeList[index].isFa == false
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            onPressed: () {
                              print("fa");
                              setState(() {
                                homeList[index].isFa = true;
                              });
                            },
                          )
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

    return Scaffold(
      body: Container(
          alignment: Alignment.topCenter,
          child: new Padding(
            padding: EdgeInsets.all(5.0),
            child: _initBoo == false
                ? const Center(
                    child: const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ))
                : new Refresh(
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
                        itemCount: homeList.length,
                      ));
                    },
                  ),
          )),
    );
  }
}
