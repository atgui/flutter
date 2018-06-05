import 'package:flutter/material.dart';
import '../../models/videomodel.dart';
import '../details/detail_page.dart';

class WrapVideoItem extends StatefulWidget {
  const WrapVideoItem({this.mod, Key key}) : super(key: key);
  final VideoModel mod;

  @override
  _WrapVideoItemState createState() => new _WrapVideoItemState();
}

class _WrapVideoItemState extends State<WrapVideoItem> {
  _touchContext() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailPage(
              key: Key('videoItem_key'),
              mod: widget.mod,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _touchContext();
        },
        child: new Container(
          width: MediaQuery.of(context).size.width / 2 - 1,
          color: Colors.black,
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: FadeInImage(
            width: MediaQuery.of(context).size.width / 2 - 1,
            placeholder: AssetImage("assets/load.gif"),
            image: NetworkImage(widget.mod.getCoverStr()),
          ),
        ));
  }
}
