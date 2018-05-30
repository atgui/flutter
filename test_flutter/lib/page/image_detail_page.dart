import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';

import '../managers/manager.dart';

///图片查看器
class ImageDetailPage extends StatefulWidget {
  const ImageDetailPage({Key key,this.imgUr}):super();
  final String imgUr;

  @override
  _ImageDetailPageState createState() {
    return new _ImageDetailPageState();
  }
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.white,),
          ),
        ),
        body: new ZoomableImage(
            new NetworkImage("${Manager.instance.resUrl}${widget.imgUr}"),
            maxScale:10.0,
            placeholder: const Center(child: const CircularProgressIndicator(backgroundColor: Colors.white ,)),
            backgroundColor: Colors.black),            
      );    
  }
}

