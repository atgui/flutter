import 'package:flutter/material.dart';
import '../managers/manager.dart';
import '../models/typemodel.dart';
import './other_page/actors_page.dart';
import './other_page/category_page.dart';
import './other_page/series_page.dart';

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
    if (types.length <= 0) {
      _getTypes();
    } else {
      setState(() {
        initBoo = true;
      });
    }
  }

  _getTypes() async {
    List<TypeModel> tList = await Manager.instance.getCategoryAll();
    if (tList.length > 0) {
      types.addAll(tList);
      setState(() {
        initBoo = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _touchContext(i) {
      var modPage;
      if (i == 0) {
        modPage = SeriesPage();
      } else if (i == 1) {
        modPage = ActorsPage();
      } else {
        modPage = CategoryPage();
      }
      Navigator
          .of(context)
          .push(new MaterialPageRoute(builder: (context) => modPage));
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      body: initBoo == false
          ? Center(
              child: const CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))
          : types.length > 0
              ? ListView.builder(
                  itemCount: types.length,
                  itemBuilder: (content, i) {
                    return GestureDetector(
                        onTap: () {
                          _touchContext(i);
                        },
                        child: Card(
                          elevation: 10.0,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: FadeInImage(
                              placeholder: AssetImage("assets/load.gif"),
                              image: NetworkImage(
                                  "${Manager.instance.resUrl}${types[i].resPath}"),
                            ),
                          ),
                        ));
                  },
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.info_outline),
                        Text("暂时没有内容哦!")
                      ],
                    ),
                  ),
                ),
    );
  }
}
