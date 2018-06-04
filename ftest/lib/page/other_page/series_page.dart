import 'dart:async';
import 'package:flutter/material.dart';
import './movie_list_page.dart';
import '../../managers/manager.dart';
import '../../models/typedetailmodel.dart';
import 'package:flutter_refresh/flutter_refresh.dart';

//系列
class SeriesPage extends StatefulWidget {
  @override
  _SeriesPageState createState() => new _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  var initBoo = false;
  List<TypeDetailModel> tdmList = [];
  var pageIndex = 0;

  @override
  void initState() {
    print("------");
    super.initState();
    _getSeris();
  }

  _getSeris() async {
    pageIndex++;
    List<TypeDetailModel> ms = await Manager.instance.getSeries(0, pageIndex);
    if (ms.length > 0) {
      tdmList.addAll(ms);
    }
    if (!mounted) return;
    setState(() {
      initBoo = true;
    });
  }

  _dispatch() {
    Navigator.pop(context);
  }

  _toMovieListPage(var mod) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MovieListPage(
                  key: Key('movie_list_page'),
                  detailModel: mod,
                  type: 0,
                )));
  }

  Future<Null> onFooterRefresh() async {
    await _getSeris();
    return null;
  }

  Future<Null> onHeaderRefresh() {
    setState(() {});
    return null;
  }
  

  @override
  Widget build(BuildContext context) {

    Widget _itemBuilder(BuildContext context, int index) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: new Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          children: tdmList.map((mod) {
            return GestureDetector(
              onTap: () {
                //跳到影片列表页面
                _toMovieListPage(mod);
              },
              child: Card(
                color: Colors.white10,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(mod.name),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    final content = Padding(
        padding: EdgeInsets.only(top: 5.0, left: 6.0, right: 6.0),
        child: Refresh(
          onFooterRefresh: onFooterRefresh,
          onHeaderRefresh: null,
          childBuilder: (BuildContext context,
              {ScrollController controller, ScrollPhysics physics}) {
            return new Container(
                child: new ListView.builder(
              physics: physics,
              controller: controller,
              itemBuilder: _itemBuilder,
              itemCount: 1,
            ));
          },
        ));
    final xContent = Container(
        child: tdmList.length <= 0
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.info_outline),
                    Text("暂时没有内容哦!")
                  ],
                ),
              )
            : content);

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '系列',
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _dispatch();
          },
        ),
      ),
      body: initBoo == false
          ? const Center(
              child: const CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))
          : xContent,
    );
  }
}
