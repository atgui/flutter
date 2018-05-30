import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;
import '../managers/manager.dart';
import '../models/TypeDetailModel.dart';
import '../models/VideoDetailModel.dart';
import '../models/VideoModel.dart';
import 'movie_list_page.dart';
// import 'package:video_player/video_player.dart';

//视频播放信息页面
class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key key, this.mod}) : super();
  final VideoModel mod;

  @override
  _VideoDetailPageState createState() => new _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  var initBoo = false;
  VideoDetailModel videoDetailModel = new VideoDetailModel(
    title: "",
    actorer: [],
    genres: [],
    m3u8: "",
  );

   var con=new VideoPlayerController.network("");

  @override
  void initState() {
    super.initState();
    _getTopMovie();
  }

  List<VideoModel> movieList = [];

  _getTopMovie() async {
    videoDetailModel = await Manager.instance.getDetail(widget.mod.shortId);
    if (videoDetailModel == null) {
      videoDetailModel = new VideoDetailModel(
        title: "",
        actorer: [],
        genres: [],
        m3u8: "",
        videoUrl: ""
      );
      return;
    }    
    if (!mounted) return;
    setState(() {
      initBoo = true;
      con = new VideoPlayerController.network(videoDetailModel != null
              ? "${Manager.instance.videoUrl}${videoDetailModel.getVideoRes()}"
              : 'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4');
    });
  }

 
  @override
  Widget build(BuildContext context) {
    var isAuto =widget.mod.horizontally==1; //是否全屏播放

    ////////////////// 正常 ///////////////////////////

    var playerVideo = new Chewie(
      // new VideoPlayerController.asset("assets/videos/1.mp4"),
      // con,
      new VideoPlayerController.network(
          // 'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4'
          // 'http://video.1av.co/assets/m3u8/032718_663.m3u8'
          videoDetailModel != null
              ? "${Manager.instance.videoUrl}${videoDetailModel.getVideoRes()}"
              : 'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4'),
      aspectRatio: 16 / 9,
      looping: false,
      autoPlay: false,
      showControls: true,
      placeholder: new Container(
        color: Colors.black,
      ),
    );
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
        children: videoDetailModel.genres.map((mod) {
          return GestureDetector(
            onTap: () {
              //跳到影片列表页面
              // var tDetailModel =
              //     new TypeDetailModel(shortId: mod.shortId, name: mod.name);
              // _toMovieListPage(tDetailModel);
            },
            child: Card(
              color: Colors.white10,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(mod.name),
              ),
            ),
          );
        }).toList());

    var content = Container(
        alignment: Alignment.centerLeft,
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: headIcon,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 8.0),
                    width: 250.0,
                    child: Text(
                        videoDetailModel != null
                            ? videoDetailModel.title
                            : "", //widget.mod.title
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              itemWrap
            ]),
          ),
        ));

    var back = GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.black54,
      ),
    );
    var nomal = new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "正在播放${widget.mod.title}",
          style: TextStyle(color: Colors.black54),
          overflow: TextOverflow.ellipsis,
        ),
        leading: back,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[playerVideo, content],
        ),
      ),
    );
    //////////////////////////// END ////////////////////////////////

    //////////////////////////// 全屏 ////////////////////////////////

    _tapCon() {
      if (con.value.isPlaying == true) {
        print("暂停");
        con.pause();
      } else {
        print("播放");
        con.play();
      }
    }

    var fullPlayerVideo = GestureDetector(
      onTap: () {
        _tapCon();
      },
      child: new Chewie(
        con,
        // new VideoPlayerController.network(
        //     // 'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4'
        //     // 'http://video.1av.co/assets/m3u8/032718_663.m3u8'
        //     videoDetailModel != null
        //         ? "${Manager.instance.videoUrl}${videoDetailModel.m3u8}"
        //         : 'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4'),
        aspectRatio: 9 / 16,
        autoPlay: true,
        looping: true,
        showControls: false,
        placeholder: new Container(
          color: Colors.black,
        ),
      ),
    );

    var pauseCon = Positioned(
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        height: 100.0,
        child: Card(
          color: new Color.fromARGB(100, 0, 0, 0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
    final widgetArr = [fullPlayerVideo, pauseCon];

    //有全屏 进度 声音
    final playerWidget = Stack(
      children: widgetArr.toList(),
    );
    return initBoo==true?(isAuto == true ? playerWidget : nomal):Container(
      child: const Center(
            child: const CircularProgressIndicator(
            backgroundColor: Colors.white,
          )),
    );
  }
}

class LabelItem extends StatefulWidget {
  @override
  _LabelItemState createState() => new _LabelItemState();
}

class _LabelItemState extends State<LabelItem> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      // color: Colors.blue,
      // alignment: Alignment.centerLeft,
      //这里应该是瀑布流
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("这里是标签"),
            ),
          ),
          Card(
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("这里是标签"),
            ),
          ),
          Card(
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Text("这里是标签"),
            ),
          )
        ],
      ),
    );
  }
}

//////////////////////////// 以下是自带播放器的 //////////////////////////////////////

// class VideoPlayPause extends StatefulWidget {
//   final VideoPlayerController controller;

//   VideoPlayPause(this.controller);

//   @override
//   State createState() {
//     return new _VideoPlayPauseState();
//   }
// }
// class _VideoPlayPauseState extends State<VideoPlayPause> {
//   FadeAnimation imageFadeAnim =
//       new FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
//   VoidCallback listener;

//   _VideoPlayPauseState() {
//     listener = () {
//       setState(() {});
//     };
//   }

//   VideoPlayerController get controller => widget.controller;

//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(listener);
//     controller.setVolume(1.0);
//     controller.play();
//   }

//   @override
//   void deactivate() {
//     controller.setVolume(0.0);
//     controller.removeListener(listener);
//     super.deactivate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = <Widget>[
//       new GestureDetector(
//         child: new VideoPlayer(controller),
//         onTap: () {
//           if (!controller.value.initialized) {
//             return;
//           }
//           if (controller.value.isPlaying) {
//             imageFadeAnim =
//                 new FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
//             controller.pause();
//           } else {
//             imageFadeAnim = new FadeAnimation(
//                 child: const Icon(Icons.play_arrow, size: 100.0));
//             controller.play();
//           }
//         },
//       ),
//       new Align(
//         alignment: Alignment.bottomCenter,
//         child: new VideoProgressIndicator(
//           controller,
//           allowScrubbing: true,
//         ),
//       ),
//       new Center(child: imageFadeAnim),
//     ];

//     return new Stack(
//       fit: StackFit.passthrough,
//       children: children,
//     );
//   }
// }
// class FadeAnimation extends StatefulWidget {
//   final Widget child;
//   final Duration duration;

//   FadeAnimation({this.child, this.duration: const Duration(milliseconds: 500)});

//   @override
//   _FadeAnimationState createState() => new _FadeAnimationState();
// }
// class _FadeAnimationState extends State<FadeAnimation>
//     with SingleTickerProviderStateMixin {
//   AnimationController animationController;

//   @override
//   void initState() {
//     super.initState();
//     animationController =
//         new AnimationController(duration: widget.duration, vsync: this);
//     animationController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//     animationController.forward(from: 0.0);
//   }

//   @override
//   void deactivate() {
//     animationController.stop();
//     super.deactivate();
//   }

//   @override
//   void didUpdateWidget(FadeAnimation oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.child != widget.child) {
//       animationController.forward(from: 0.0);
//     }
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return animationController.isAnimating
//         ? new Opacity(
//             opacity: 1.0 - animationController.value,
//             child: widget.child,
//           )
//         : new Container();
//   }
// }
// typedef Widget VideoWidgetBuilder(
//     BuildContext context, VideoPlayerController controller);

// abstract class PlayerLifeCycle extends StatefulWidget {
//   final VideoWidgetBuilder childBuilder;
//   final String dataSource;

//   PlayerLifeCycle(this.dataSource, this.childBuilder);
// }
// /// A widget connecting its life cycle to a [VideoPlayerController] using
// /// a data source from the network.
// class NetworkPlayerLifeCycle extends PlayerLifeCycle {
//   NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
//       : super(dataSource, childBuilder);

//   @override
//   _NetworkPlayerLifeCycleState createState() =>
//       new _NetworkPlayerLifeCycleState();
// }
// /// A widget connecting its life cycle to a [VideoPlayerController] using
// /// an asset as data source
// class AssetPlayerLifeCycle extends PlayerLifeCycle {
//   AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
//       : super(dataSource, childBuilder);

//   @override
//   _AssetPlayerLifeCycleState createState() => new _AssetPlayerLifeCycleState();
// }
// abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
//   VideoPlayerController controller;

//   @override

//   /// Subclasses should implement [createVideoPlayerController], which is used
//   /// by this method.
//   void initState() {
//     super.initState();
//     controller = createVideoPlayerController();
//     controller.addListener(() {
//       if (controller.value.hasError) {
//         print(controller.value.errorDescription);
//       }
//     });
//     controller.initialize();
//     controller.setLooping(true);
//     controller.play();
//   }

//   @override
//   void deactivate() {
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.childBuilder(context, controller);
//   }

//   VideoPlayerController createVideoPlayerController();
// }
// class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
//   @override
//   VideoPlayerController createVideoPlayerController() {
//     return null; //new VideoPlayerController.network(widget.dataSource);
//   }
// }
// class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
//   @override
//   VideoPlayerController createVideoPlayerController() {
//     return null; //new VideoPlayerController.asset(widget.dataSource);
//   }
// }
// /// A filler card to show the video in a list of scrolling contents.
// Widget buildCard(String title) {
//   return new Card(
//     child: new Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         new ListTile(
//           leading: const Icon(Icons.airline_seat_flat_angled),
//           title: new Text(title),
//         ),
//         new ButtonTheme.bar(
//           child: new ButtonBar(
//             children: <Widget>[
//               new FlatButton(
//                 child: const Text('BUY TICKETS'),
//                 onPressed: () {/* ... */},
//               ),
//               new FlatButton(
//                 child: const Text('SELL TICKETS'),
//                 onPressed: () {/* ... */},
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
// class VideoInListOfCards extends StatelessWidget {
//   final VideoPlayerController controller;

//   VideoInListOfCards(this.controller);

//   @override
//   Widget build(BuildContext context) {
//     return new ListView(
//       children: <Widget>[
//         buildCard("Item a"),
//         buildCard("Item b"),
//         buildCard("Item c"),
//         buildCard("Item d"),
//         buildCard("Item e"),
//         buildCard("Item f"),
//         buildCard("Item g"),
//         new Card(
//             child: new Column(children: <Widget>[
//           new Column(
//             children: <Widget>[
//               const ListTile(
//                 leading: const Icon(Icons.cake),
//                 title: const Text("Video video"),
//               ),
//               new Stack(
//                   alignment: FractionalOffset.bottomRight +
//                       const FractionalOffset(-0.1, -0.1),
//                   children: <Widget>[
//                     new AspectRatioVideo(controller),
//                     new Image.asset('assets/flutter-mark-square-64.png'),
//                   ]),
//             ],
//           ),
//         ])),
//         buildCard("Item h"),
//         buildCard("Item i"),
//         buildCard("Item j"),
//         buildCard("Item k"),
//         buildCard("Item l"),
//       ],
//     );
//   }
// }
// class AspectRatioVideo extends StatefulWidget {
//   final VideoPlayerController controller;

//   AspectRatioVideo(this.controller);

//   @override
//   AspectRatioVideoState createState() => new AspectRatioVideoState();
// }
// class AspectRatioVideoState extends State<AspectRatioVideo> {
//   VideoPlayerController get controller => widget.controller;
//   bool initialized = false;

//   VoidCallback listener;

//   @override
//   void initState() {
//     super.initState();
//     listener = () {
//       if (controller.value.hasError == true &&
//           controller.value.initialized == false) {
//         //弹出提示
//         SnackBar snackBar = new SnackBar(
//           content: Text("视频加载出错 ->${controller.value.initialized}"),
//         );
//         Scaffold.of(context).showSnackBar(snackBar);
//       }

//       // print("视频加载中 ->ERROR:${controller.value.hasError}   ::::INIT::${controller.value.initialized}");
//       if (!mounted) {
//         return;
//       }
//       if (initialized != controller.value.initialized) {
//         initialized = controller.value.initialized;
//         setState(() {});
//       }
//     };
//     controller.addListener(listener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (initialized) {
//       final Size size = controller.value.size;
//       return new Center(
//         child: new AspectRatio(
//           aspectRatio: size.width / size.height,
//           child: new VideoPlayPause(controller),
//         ),
//       );
//     } else {
//       return new Container(
//         child: SizedBox(
//           height: 150.0,
//           width: MediaQuery.of(context).size.width,
//           child: Container(
//             color: Colors.black,
//           ),
//         ),
//       );
//     }
//   }
// }
