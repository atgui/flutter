import 'dart:async';

import 'package:flutter/material.dart';

import '../../managers/manager.dart';
import '../../models/typedetailmodel.dart';
import 'movie_list_page.dart';
import 'package:flutter_refresh/flutter_refresh.dart';

//女优
class ActorsPage extends StatefulWidget {
  @override
  _ActorsPageState createState() => new _ActorsPageState();
}

class _ActorsPageState extends State<ActorsPage> {
  var initBoo = false;
  List<TypeDetailModel> tdmList = [];
  var pageIndex=0;

  @override
  void initState() {
    print("------");
    super.initState();
    _getSeris();
  }

 _getSeris() async {
   pageIndex++;
    List<TypeDetailModel> ms= await Manager.instance.getSeries(1,pageIndex);
    if (ms.length >0) {
      tdmList.addAll(ms);
    }    
    if(!mounted)return;
    setState(() {
        initBoo=true;    
      });
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
    _toMovieListPage(var mod){
      Navigator.push(context,
        new MaterialPageRoute(
          builder: (context)=>MovieListPage(key:Key('movie_list_page'),detailModel: mod,type: 1,)
          )
      );
    }

    Widget _itemBuilder(BuildContext context, int index) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: new Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: tdmList.map((mod) {
                return GestureDetector(
                  onTap: (){//跳到影片列表页面
                    _toMovieListPage(mod);
                  },
                  child: Card(
                  // elevation: 10.0,
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

    
    _dispatch() {
      Navigator.pop(context);
    }
    
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('女优',style: TextStyle(color: Colors.black54),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _dispatch();
          },
        ),
      ),
      body: initBoo == false?const Center(child: const CircularProgressIndicator(backgroundColor: Colors.white ,)):
          Container(
            child: tdmList.length<=0?Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.info_outline),
                  Text("暂时没有内容哦!")
                ],
              ),
            ):Refresh(
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
                          itemCount: 1,
                        ));
                      },
                    ),
          ),
    );
  }
}