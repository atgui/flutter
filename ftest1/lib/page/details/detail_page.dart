import 'package:flutter/material.dart';
import '../../managers/manager.dart';
import '../../models/detaimodel.dart';
import '../../models/videomodel.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.mod}) : super();
  final VideoModel mod;

  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var initBoo = false;
  VideoPlayerController _controller = new VideoPlayerController.asset("");
  VideoDetailModel detailModel = new VideoDetailModel(genres: []);

  var isLoad = false;

  _getDetail() async {
    detailModel = await Manager.instance.getDetail(widget.mod.shortId);
    if (detailModel == null) {
      detailModel = new VideoDetailModel(
          title: "",
          actorer: [],
          genres: [],
          m3u8: "",
          videoUrl: "",
          thumbHigh: "");
      return;
    }
    detailModel.genres = [];
    if (!mounted) return;
    setState(() {
      initBoo = true;
      _controller = new VideoPlayerController.network(detailModel !=//
              null //"https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4"//
          ? "https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4"//"http://res.gittask.com/assets/1pondo/M3U8/1527909531428.m3u8"//"${Manager.instance.videoUrl}${detailModel.getVideoRes()}"
          : 'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4');
    });
  }

  @override
  void initState() {
    super.initState();
    _getDetail();
//    _controller = new VideoPlayerController.network(
//      'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4',
//    );
//    _controller.setVolume(1.0);

    _controller.addListener(() {
      print("状态:${_controller.value.initialized}");
    });
  }

  @override
  Widget build(BuildContext context) {
    var isFlull = widget.mod.horizontally == 0;

    //要判断是Android 还是 IOS IOS 暂时还不能自动播放
    final fullView = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: new Stack(
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: new Chewie(
                _controller,
                aspectRatio: 9 / 16,
                autoPlay: false,
                looping: true,
                showControls: true,

                // Try playing around with some of these other options:

                // materialProgressColors: new ChewieProgressColors(
                //   playedColor: Colors.red,
                //   handleColor: Colors.blue,
                //   backgroundColor: Colors.grey,
                //   bufferedColor: Colors.lightGreen,
                // ),
                placeholder: Container(
                  child: const Center(
                      child: const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )),
                ),
                // autoInitialize: true,
              ),
            ),
          ),
//          Positioned(
//            top: 5.0,
//            left: 00.0,
////            height: 200.0,
//            child: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: (){
//              Navigator.pop(context);
//            },),
//          ),
        ],
      ),
    );

    ////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////

    //头像
    var headIcon = new CircleAvatar(
      foregroundColor: Colors.black,
      backgroundImage: NetworkImage(
          '${Manager.instance.resUrl}${widget.mod.avatar}'), //new AssetImage('assets/head.jpg'),
      radius: 30.0,
    );
    var itemWrap = Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: detailModel.genres.map((mod) {
          return GestureDetector(
            onTap: () {
              //跳到影片列表页面
              // var tDetailModel =
              //     new TypeDetailModel(shortId: mod.shortId, name: mod.name);
              // _toMovieListPage(tDetailModel);
            },
            child: Card(
              color: Colors.white,
              elevation: 10.0,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(mod.name),
              ),
            ),
          );
        }).toList());

    final noFullView = Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '正在播放:${widget.mod.title}',
          style: TextStyle(color: Colors.black54),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Card(
              color: Colors.white,
              elevation: 10.0,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: new Chewie(
                  _controller,
                  aspectRatio: 16 / 9,
                  autoPlay: false,
                  looping: true,
                  showControls: true,

                  // Try playing around with some of these other options:

                  // materialProgressColors: new ChewieProgressColors(
                  //   playedColor: Colors.red,
                  //   handleColor: Colors.blue,
                  //   backgroundColor: Colors.grey,
                  //   bufferedColor: Colors.lightGreen,
                  // ),
                  placeholder: new Container(
                    color: Colors.black,
                  ),
                  // autoInitialize: true,
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 10.0,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        headIcon,
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "这里是标题这里是标题这里是标题这里是标题这里是标题这里是标题这里是标题",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    //这里是标签
                    SizedBox(
                      height: 10.0,
                    ),
                    itemWrap,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return isFlull == true ? fullView : noFullView;
  }
}
