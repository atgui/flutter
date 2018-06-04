import 'package:flutter/material.dart';
import '../../managers/system_manager.dart';
import '../../managers/manager.dart';
import '../../models/detaimodel.dart';
import '../../models/videomodel.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.mod}) : super();
  final VideoModel mod;

  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var initBoo = false;
  VideoDetailModel detailModel = new VideoDetailModel(genres: []);

  var isLoad = false;
  VideoPlayerController _controller; //=new VideoPlayerController.network("");
  var isPlayer = false;
  var isInitPlayer = false;

  var videoUrl = "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
//  var videoUrl="assets/tvideo.mp4";
  var listener;

  var imgUrl = "";

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

    if (!mounted) return;
    videoUrl = Manager.instance.videoUrl + "" + detailModel.getVideoRes();
    listener = () {
      print(
          "INIT:${_controller.value.initialized} ::ISPLAYER:${_controller.value.isPlaying}");
      if (_controller.value.isPlaying &&
          _controller.value.initialized == true &&
          isInitPlayer == false) {
        isInitPlayer = true;
        setState(() {
         isPlayer = _controller.value.isPlaying;
        });
      }
    };
    _controller = new VideoPlayerController.network(
      videoUrl,
    )
      ..addListener(listener)
      ..initialize()
      ..play();
    setState(() {
      imgUrl = "${Manager.instance.resUrl}${detailModel.thumbHigh}";
      print("URL:::=${imgUrl}");
      initBoo = true;
    });
  }

  @override
  void initState() {
    super.initState();

    SystemManager.instance.initPlatformState();
    _getDetail();
  }

  _closeContext() async {
    var oo = SystemManager.systemOs() == "IOS";
    _controller.removeListener(listener);
    if (oo == true) {
      _controller.timer?.cancel();
      await _controller.pause();
    } else {
      await _controller.dispose();
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _closeContext();
  }

  @override
  Widget build(BuildContext context) {
    var isFlull = widget.mod.horizontally == 1;

    //全屏
    final fullView = new Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          isPlayer == true
              ? new AspectRatio(
                  aspectRatio: 9 / 16,
                  child: new VideoPlayer(_controller),
                )
              : imgUrl != ""
                  ? Center(
                      child: FadeInImage(
                      placeholder: AssetImage('assets/init.jpg'),
                      image: NetworkImage(imgUrl),
                    ) //CircularProgressIndicator(backgroundColor: Colors.transparent,),
                      )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                      ),
                    ),
          Positioned(
            top: 20.0,
            child: Card(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  _closeContext();
                  Navigator.pop(context);
                },
              ),
            ),
          )
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
              child: Padding(padding: EdgeInsets.all(5.0), child: Center()
//                new NetworkPlayerLifeCycle(
//                  'http://res.gittask.com/assets/1pondo/M3U8/1527909531428.m3u8',
//                      (BuildContext context, VideoPlayerController controller) =>
//                  new AspectRatioVideo(controller),
//                ),
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

    return fullView; //isFlull == true ? fullView : noFullView;
  }
}

class VideoPlayPause extends StatefulWidget {
  final VideoPlayerController controller;

  VideoPlayPause(this.controller);

  @override
  State createState() {
    return new _VideoPlayPauseState();
  }
}

class _VideoPlayPauseState extends State<VideoPlayPause> {
  FadeAnimation imageFadeAnim =
      new FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
  VoidCallback listener;

  _VideoPlayPauseState() {
    listener = () {
      setState(() {});
    };
  }

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    controller.setVolume(1.0);
    controller.play();
  }

  @override
  void deactivate() {
    controller.setVolume(0.0);
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      new GestureDetector(
        child: new VideoPlayer(controller),
        onTap: () {
          if (!controller.value.initialized) {
            return;
          }
          if (controller.value.isPlaying) {
            imageFadeAnim =
                new FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
            controller.pause();
          } else {
            imageFadeAnim = new FadeAnimation(
                child: const Icon(Icons.play_arrow, size: 100.0));
            controller.play();
          }
        },
      ),
      new Align(
        alignment: Alignment.bottomCenter,
        child: new VideoProgressIndicator(
          controller,
          allowScrubbing: true,
        ),
      ),
      new Center(child: imageFadeAnim),
      new Center(
          child: controller.value.isBuffering
              ? const CircularProgressIndicator()
              : null),
    ];

    return new Stack(
      fit: StackFit.passthrough,
      children: children,
    );
  }
}

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  FadeAnimation({this.child, this.duration: const Duration(milliseconds: 500)});

  @override
  _FadeAnimationState createState() => new _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        new AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? new Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : new Container();
  }
}

typedef Widget VideoWidgetBuilder(
    BuildContext context, VideoPlayerController controller);

abstract class PlayerLifeCycle extends StatefulWidget {
  final VideoWidgetBuilder childBuilder;
  final String dataSource;

  PlayerLifeCycle(this.dataSource, this.childBuilder);
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// a data source from the network.
class NetworkPlayerLifeCycle extends PlayerLifeCycle {
  NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _NetworkPlayerLifeCycleState createState() =>
      new _NetworkPlayerLifeCycleState();
}

/// A widget connecting its life cycle to a [VideoPlayerController] using
/// an asset as data source
class AssetPlayerLifeCycle extends PlayerLifeCycle {
  AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
      : super(dataSource, childBuilder);

  @override
  _AssetPlayerLifeCycleState createState() => new _AssetPlayerLifeCycleState();
}

abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
  VideoPlayerController controller;

  @override

  /// Subclasses should implement [createVideoPlayerController], which is used
  /// by this method.
  void initState() {
    super.initState();
    controller = createVideoPlayerController();
    controller.addListener(() {
      if (controller.value.hasError) {
        print(controller.value.errorDescription);
      }
    });
    controller.initialize();
    controller.setLooping(true);
    controller.play();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(context, controller);
  }

  VideoPlayerController createVideoPlayerController();
}

class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.network(widget.dataSource);
  }
}

class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
  @override
  VideoPlayerController createVideoPlayerController() {
    return new VideoPlayerController.asset(widget.dataSource);
  }
}

/// A filler card to show the video in a list of scrolling contents.
Widget buildCard(String title) {
  return new Card(
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.airline_seat_flat_angled),
          title: new Text(title),
        ),
        new ButtonTheme.bar(
          child: new ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {/* ... */},
              ),
              new FlatButton(
                child: const Text('SELL TICKETS'),
                onPressed: () {/* ... */},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class VideoInListOfCards extends StatelessWidget {
  final VideoPlayerController controller;

  VideoInListOfCards(this.controller);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        buildCard("Item a"),
        buildCard("Item b"),
        buildCard("Item c"),
        buildCard("Item d"),
        buildCard("Item e"),
        buildCard("Item f"),
        buildCard("Item g"),
        new Card(
            child: new Column(children: <Widget>[
          new Column(
            children: <Widget>[
              const ListTile(
                leading: const Icon(Icons.cake),
                title: const Text("Video video"),
              ),
              new Stack(
                  alignment: FractionalOffset.bottomRight +
                      const FractionalOffset(-0.1, -0.1),
                  children: <Widget>[
                    new AspectRatioVideo(controller),
                    new Image.asset('assets/flutter-mark-square-64.png'),
                  ]),
            ],
          ),
        ])),
        buildCard("Item h"),
        buildCard("Item i"),
        buildCard("Item j"),
        buildCard("Item k"),
        buildCard("Item l"),
      ],
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  final VideoPlayerController controller;

  AspectRatioVideo(this.controller);

  @override
  AspectRatioVideoState createState() => new AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      final Size size = controller.value.size;
      return new Center(
        child: new AspectRatio(
          aspectRatio: size.width / size.height,
          child: new VideoPlayPause(controller),
        ),
      );
    } else {
      return new Container();
    }
  }
}
