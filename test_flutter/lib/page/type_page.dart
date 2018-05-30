import 'package:flutter/material.dart';

import '../managers/manager.dart';
import '../models/TypeModel.dart';
import './series_page.dart';
import './actors_page.dart';
import './category_page.dart';

List<TypeModel> types = [];

class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() => new _TypePageState();
}

class _TypePageState extends State<TypePage> {
  var initBoo = false;
  @override
  void initState() {
    super.initState();
    print("type initState---------------${types.length}");
    if (types.length <= 0) {
      getAllType();
    } else {
      setState(() {initBoo=true;});
    }
  }

  getAllType() async {
    types = await Manager.instance.getCategoryAll();
    if (!mounted) return;
    setState(() {
      initBoo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _content = new Scaffold(
        body: types.length > 0
            ? ListView.builder(
                itemCount: types.length,
                itemBuilder: (context, i) =>
                    TypeItem(key: Key('typeItem_key'), mod: types[i]),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[Icon(Icons.info_outline), Text("暂时没有内容")],
                ),
              ));
    final _cProgress = Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );

    return initBoo == false ? _cProgress : _content;
  }
}

class TypeItem extends StatefulWidget {
  const TypeItem({Key key, this.mod}) : super(key: key);
  final TypeModel mod;

  @override
  _TypeItemState createState() => new _TypeItemState();
}

class _TypeItemState extends State<TypeItem> {
  @override
  Widget build(BuildContext context) {
    _tapToPage() {
      var kind = widget.mod.modelKind;
      MaterialPageRoute materialPageRoute;
      if (kind == 3) {
        //系列
        materialPageRoute =
            new MaterialPageRoute(builder: (context) => SeriesPage());
      } else if (kind == 2) {
        //女优
        materialPageRoute =
            new MaterialPageRoute(builder: (context) => ActorsPage());
      } else if (kind == 1) {
        //类型
        materialPageRoute =
            new MaterialPageRoute(builder: (context) => CategoryPage());
      } else {
        //默认
        materialPageRoute =
            new MaterialPageRoute(builder: (context) => ActorsPage());
      }
      Navigator.of(context).push(materialPageRoute);
    }

    //icon
    var img = GestureDetector(
      onTap: () {
        _tapToPage();
      },
      child: FadeInImage(
        placeholder: AssetImage("assets/test.jpg"),
        image: NetworkImage('${Manager.instance.resUrl}${widget.mod.resPath}'),
      ),
    );

    var title = GestureDetector(
      onTap: () {
        _tapToPage();
      },
      child: new Text(
        widget.mod.name,
        style: new TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent),
      ),
    );

    var item = new Stack(children: <Widget>[
      img,
      new Positioned(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        left: 0.0,
        top: 0.0,
        child: Center(
          child: title,
        ),
      ),
    ]);

    return new Card(
      elevation: 10.0,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: item,
      ),
    );
  }
}
