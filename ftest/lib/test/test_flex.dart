import 'dart:math';

import 'package:flutter/material.dart';


void main()=>runApp(
  new MaterialApp(
    debugShowCheckedModeBanner: false,
    home:FlexPage(),
  )
);


class FlexPage extends StatefulWidget {
  @override
  _FlexPageState createState() => new _FlexPageState();
}

class _FlexPageState extends State<FlexPage> {
  @override
  Widget build(BuildContext context) {
    //...
    List<Container> _buildGridTileList(int count) {
      return new List<Container>.generate(
          count,
              (int index) => new Container(child: new Image.asset('assets/init.jpg'))
      );
    }
    Widget buildGrid() {
      return new GridView.extent(
          maxCrossAxisExtent: 150.0,
          padding: const EdgeInsets.all(0.0),
          mainAxisSpacing: 1.0,
          crossAxisSpacing:1.0,
          children: _buildGridTileList(20)
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("vvv"),
      ),
      body: new Center(
        child:// Text("vvvvvv")
        Flow(
          delegate: new MyFlowDelegate(padding: 1.0),
        children: [1,2,3,3,3,33,].map((t){
          var ix=Random().nextInt(150)+50;
          return Image(image: AssetImage("assets/init.jpg",),width: ix.toDouble(),);
        }).toList(),
        )
      ),
      );
    //...
  }

}

class MyFlowDelegate extends FlowDelegate {
  double padding = 0.0;

  MyFlowDelegate({this.padding});
  @override
  void paintChildren(FlowPaintingContext context) {
    var tempWidth = 0.0;
    var tempHeight = 0.0;
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + tempWidth + padding;
      if (w < context.size.width) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                tempWidth + padding, tempHeight, 0.0));
        tempWidth = w;
      } else {
        tempWidth = 0.0;
        tempHeight += context.getChildSize(i).height + padding;
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                tempWidth + padding, tempHeight, 0.0));
        tempWidth += context.getChildSize(i).width + padding;
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints){
    BoxConstraints boxConstraints = new BoxConstraints(maxHeight: constraints.maxHeight,maxWidth: constraints.maxWidth);
    return boxConstraints;
  }
}