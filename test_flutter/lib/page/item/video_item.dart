import 'package:flutter/material.dart';
import '../../managers/manager.dart';
import '../../models/VideoModel.dart';
import '../video_detail_page.dart';
import 'package:transparent_image/transparent_image.dart';

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
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ImageDetailPage(
        //           key: Key('image_detail_page_key'),
        //           imgUr: widget.mod.cover,
        //         )));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoDetailPage(
                  key: Key('videoItem_key'),
                  mod: widget.mod,
                )));
      },
      child:
          // Stack(
          //   children: <Widget>[
          //     // new Center(child: new CircularProgressIndicator()),
          //     new Center(
          //       child: new FadeInImage.memoryNetwork(
          //         placeholder: kTransparentImage,
          //         image:"http://res.1av.co${widget.mod.cover}",
          //       ),
          //     ),
          //   ],
          // )
          // (
          //       placeholder: new CircularProgressIndicator(),
          //       imageUrl:
          //           'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
          //     )
          FadeInImage(
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
        // scaffoldState.showSnackBar(SnackBar(
        //   backgroundColor: Colors.blue,
        //   content: Text("title->导航跳转到播放页面"),
        // ));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoDetailPage(
                  key: Key('videoItem_key'),
                  mod: widget.mod,
                )));
      },
      child: Container(
        width: 250.0,
        child: Text(
          widget.mod.title,
          // "这里是标题这里是标题",
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
