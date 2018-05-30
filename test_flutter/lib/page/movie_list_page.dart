import 'dart:async';

import 'package:flutter/material.dart';
import '../managers/manager.dart';
import '../models/TypeDetailModel.dart';
import '../models/VideoModel.dart';
import 'item/video_item.dart';
import 'package:flutter_refresh/flutter_refresh.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({Key key, this.detailModel, this.type});
  final TypeDetailModel detailModel;
  final int type;

  @override
  _MovieListPageState createState() => new _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  var initBoo = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  List<VideoModel> seriesList = [];
  List<VideoModel> list = [];
  var pageIndex = 0;

  //得到数据
  _getData() async {
    pageIndex++;
    String sId = widget.detailModel.shortId;
    List<VideoModel> vms =
        await Manager.instance.getList(widget.type, sId, pageIndex);
    if (vms.length > 0) {
      seriesList.addAll(vms);
      list = seriesList;
    }
    if (!mounted) return;
    setState(() {
      initBoo = true;
    });
  }

  Future<Null> onFooterRefresh() async {
    await _getData();
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
        key: Key("list_item"),
        mod: list[index],
      );
    }

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "影片列表",
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: initBoo == false
          ? const Center(
              child: const CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))
          : Container(
              child: seriesList.length <= 0
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Icon(Icons.info_outline),
                          Text("暂时没有影片哦!")
                        ],
                      ),
                    )
                  : Refresh(
                      onFooterRefresh: onFooterRefresh,
                      onHeaderRefresh: null,
                      childBuilder: (BuildContext context,
                          {ScrollController controller,
                          ScrollPhysics physics}) {
                        return new Container(
                            child: new ListView.builder(
                          physics: physics,
                          controller: controller,
                          itemBuilder: _itemBuilder,
                          itemCount: list.length,
                        ));
                      },
                    ),
            ),
    );
  }
}
