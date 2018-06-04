import 'package:flutter/cupertino.dart';
import '../item/wrap_video_item.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import '../../models/videomodel.dart';

class CommonRefresh{
  List<VideoModel> list;

  Widget itemBuilder1(BuildContext context,int index){
    return Container(
      padding: EdgeInsets.all(0.0),
      alignment: Alignment.center,
      child: new Wrap(
        spacing: 1.0, // gap between adjacent chips
        runSpacing: 1.0, // gap between lines
        children: this.list.map((mod) {
          return new WrapVideoItem(mod: mod,);
        }).toList(),
      ),
    );
  }

  var onFooterRefresh;
  var onHeaderRefresh;
  //数据刷新
  Refresh getContext(list,onFoot,onHeader){
    this.list=list;
    this.onFooterRefresh=onFoot;
    this.onHeaderRefresh=onHeader;

    return Refresh(
      //刷新
      onFooterRefresh: onFooterRefresh,
      onHeaderRefresh: null,
      childBuilder: (BuildContext context,
          {ScrollController controller, ScrollPhysics physics}) {
        return new Container(
            child: new ListView.builder(
              physics: physics,
              controller: controller,
              itemBuilder: itemBuilder1,
              itemCount: 1,
            ));
      },
    );
  }

}