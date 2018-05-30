class VideoDetailModel{
  var m3u8;
  var videoUrl;
  var title;
  List<ActorerModel> actorer;

  String getVideoRes(){
    // if(m3u8=="null"||m3u8==null){
      return this.videoUrl;
    // }
    // return m3u8;
  }

  VideoDetailModel({this.m3u8,this.videoUrl,this.title,this.actorer,this.genres});
  List<Genre> genres;
  @override
    String toString() {
      // TODO: implement toString
      return "[m3u8=${this.m3u8},videoUrl=${this.videoUrl},title=${this.title},actorer=${this.actorer.toString()}]";
    }
}
class ActorerModel{
  var shortId;//ID
  var imgPath;//头像地址
  var name;//姓名

  ActorerModel({this.shortId,this.imgPath,this.name});

  @override
    String toString() {
      // TODO: implement toString
      return "[shortId=${this.shortId},name=${this.name},imgPath=${this.imgPath}]";
    }
  static List<ActorerModel> fromJson(List json){
    if(json==null){
      return [];
    }
    if(json==null||json.length<=0){
      return [];
    }
    return json.map((string) => new ActorerModel(
      shortId: string['shortId'],
      imgPath: string['imgPath'],
      name: string['name']
      )).toList();
  }
}
class Genre{
  var shortId;
  var name;
  Genre({this.shortId,this.name});
  static List<Genre> fromJson(List json){
    if(json==null){
      return [];
    }
    if(json==null||json.length<=0){
      return [];
    }
    return json.map((string) => new Genre(
      shortId: string['shortId'],
      name: string['name']
      )).toList();
  }
}