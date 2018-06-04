import 'dart:math';

import '../managers/manager.dart';

class VideoModel{
  var avatar;//头像
  var actor;//演员
  var title;//标题
  var movieThumb;//影片缩略图(无法访问?)
  var time;//影片时长
  var cover;//影片缩略图
  var release;//发布日期
  var shortId;//ID
  var horizontally;//是否全屏 1:全屏
  var isFa=false;

  String getCoverStr(){
    var str="${Manager.instance.resUrl}${this.cover}";
    return str;
  }
  String getAvatarRes(){
//    if(this.avatar==""||this.avatar=="null"){
//      return "";
//    }
    return this.avatar;
  }

  String getDate() {
    var dateStr ="未知";
    if (release != null) {
      var n=num.parse(release.toString().trim());
      var date=DateTime.fromMillisecondsSinceEpoch(n);
      dateStr ="${date.year}-${date.month}-${date.day}";
    }
    return dateStr;
  }


  String getTime(){
    var timeStr="0";
    var n=num.parse(time.toString().trim());
    var v=n/60;//得到分钟 进行四舍五入
    var vStr=v.round();
    timeStr="${vStr}分钟";
    return timeStr;
  }

  VideoModel({this.title,this.movieThumb,this.horizontally,this.time,this.cover,this.shortId,this.actor,this.release,this.avatar});
  @override
  toString(){
    return "[title="+this.title+",movieThumb="+this.movieThumb+',avatar='+this.avatar+",actor="+
        this.actor+",time="+this.time+",cover="+this.cover+",shortId="+this.shortId+"release="+this.release+"]";
  }

  static List<VideoModel> fromJson(List json){
    if(json==null||json.length<=0){
      return [];
    }
    return json.map((string) => new VideoModel(
        title: string['title'],
        movieThumb: string['movieThumb'],
        horizontally: string['horizontally'],
        time: string['time'],
        actor: string['actor'],
        avatar: string["avatar"],
        shortId: string['shortId'],
        cover: string['cover'],
        release: string['release']
    )).toList();
  }
}