import 'package:flutter/material.dart';
import '../../managers/manager.dart';
import '../../models/videomodel.dart';
import '../details/detail_page.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({Key key, this.mod}) : super(key: key);

  final VideoModel mod;

  @override
  _VideoItemState createState() => new _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  String getTime(value) {
    return new DateTime.fromMicrosecondsSinceEpoch(value).toLocal().toString();
  }

  @override
  Widget build(BuildContext context) {
    // var scaffoldState = Scaffold.of(context);

    //头像
    var headIcon = new CircleAvatar(
      foregroundColor: Colors.greenAccent,
      backgroundImage: NetworkImage(
          "${Manager.instance.resUrl}${widget.mod.avatar}"), //AssetImage('assets/head.jpg'),new AssetImage('assets/head.jpg'),//
      radius: 30.0,
    );

    //icon
    var img = GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(
                  key: Key('videoItem_key'),
                  mod: widget.mod,
                )));
      },
      child: FadeInImage(
        placeholder: AssetImage(
            "assets/test.jpg"), //new Image(image: Image.asset(""),).image,
        image: NetworkImage(
            "${Manager.instance.resUrl}${widget.mod.cover}"), //AssetImage('assets/test.jpg'),//
      ),
    );

    //日期和时间
    var date_time = Container(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.date_range),
          new Text("${widget.mod.getDate()}"),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
          ),
          Icon(Icons.timer),
          new Text('${widget.mod.getTime()}'),
        ],
      ),
    );

    //标题
    var title = GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                DetailPage(key: Key('videoItem_key'), mod: widget.mod)));
      },
      child: Container(
        width: 250.0,
        child: Text(
          widget.mod.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );

    //内容显示
    var content = Padding(
      padding: EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //这里应该是圆形头像
          // Icon(Icons.info),
          headIcon,
          Padding(
            padding: EdgeInsets.only(left: 5.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              title,
              SizedBox(
                height: 5.0,
              ),
              //日期和时间
              date_time
            ],
          )
        ],
      ),
    );

    return Column(
      children: <Widget>[
        new Card(
          elevation: 20.0,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[img, content],
            ),
          ),
        ),
      ],
    );
  }
}
