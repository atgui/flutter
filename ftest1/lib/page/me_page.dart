import 'package:flutter/material.dart';

import '../managers/manager.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() {
    return new _MePageState();
  }
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    //头像
    final headIcon = Container(
      // color: Colors.blue,
      alignment: Alignment.topCenter,
      height: 150.0,
      child: new CircleAvatar(
        foregroundColor: Colors.black,
        backgroundImage:new AssetImage('assets/head.jpg'),
        // NetworkImage(
        //     '${Manager.instance.resUrl}${widget.mod.avatar}'), //
        radius: 70.0,
      ),
    );

     _content(txt){
      return Container(
    // color: Colors.blue,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    height: 40.0,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children:<Widget>[
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
    Padding(
    padding: EdgeInsets.all(1.0),
    child: Text(txt,style: TextStyle(fontSize: 20.0,color: Colors.black54,
    )),
               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 10.0),
//                 child: Text(">",style: TextStyle(fontSize: 20.0,color: Colors.black54, )),
//               ),
             ],
           ),
//           Text("______________________________________",style: TextStyle(color: Colors.grey),),
         ],
      )
    );
  }

    final fac = Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children:["我的账户","会员中心","我的账户","会员中心","退出登陆"].map((t){
        return _content(t);
      }).toList(),
    );

    //收藏
    final collect=Container(
        width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      height: 50.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(Icons.favorite_border),Text("收藏"),
                Container(
                  padding: EdgeInsets.only(left: 10.0,right: 10.0),
                  child: Text("|",style: TextStyle(fontSize: 20.0,color: Colors.grey)),
                ),
                Icon(Icons.share),Text("分享")
              ],
            ),
            Text("_____________________________________________",style: TextStyle(color: Colors.grey),)
          ],
        ),
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text("个人中心",style: TextStyle(color: Colors.black54),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: Padding(
        padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[headIcon,collect, fac],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
