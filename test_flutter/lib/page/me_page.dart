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
      height: 200.0,
      child: new CircleAvatar(
        foregroundColor: Colors.black,
        backgroundImage:new AssetImage('assets/head.jpg'),
        // NetworkImage(
        //     '${Manager.instance.resUrl}${widget.mod.avatar}'), //
        radius: 100.0,
      ),
    );

    final _content=Container(
            // color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,                
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("个人信息",style: TextStyle(fontSize: 20.0,color: Colors.black54,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(">",style: TextStyle(fontSize: 20.0,color: Colors.black54, )),
                  ),                  
                ],
              ),
            ),
          );

    final fac = Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: [1,2,3,4,5,6].map((t){
          return _content;
        }).toList(),
        );

    return new Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[headIcon, fac],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
