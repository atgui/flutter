import 'package:flutter/material.dart';

class TypeDetailPage extends StatefulWidget {
  const TypeDetailPage({Key key,this.type});
  //0:系列  1:女优  2:类型
  final type;
  @override
  _TypeDetailPageState createState() => new _TypeDetailPageState();
}

class _TypeDetailPageState extends State<TypeDetailPage> {
  var initBoo=false;

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return initBoo==false?new Container(
      
    ):ListView.builder(
      itemCount: 10,
      itemBuilder: (context,i)=>Text("测试"),);
  }
}

