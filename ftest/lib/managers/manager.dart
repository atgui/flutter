import 'dart:async';
import 'dart:convert';
import './system_manager.dart';
import '../models/detaimodel.dart';
import '../models/typemodel.dart';
import '../models/videomodel.dart';
import 'package:http/http.dart' as Http;


class Manager {
  Manager() {}
  static Manager _singleton = null;
  Manager._internal();
  static Manager get instance {
    if (_singleton == null) {
      _singleton = new Manager();
    }
    return _singleton;
  }

  var token ="";
  // var apiUrl = "http://api.1av.co/api/v1";
  var apiUrl = "http://128.14.30.138:83/api/v1";
  var resUrl = "http://128.14.30.138:83/";
//  VersionModel versionModel = null;
  var videoUrl = "http://128.14.30.138:83/";




  //得到服务器api ip
  Future<bool> getServer() async{
    var boo=true;
    var url="http://jres.oss-us-east-1.aliyuncs.com/datahu.json";
    Http.Response response=await Http.get(url,headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
    }).catchError((){
      boo=false;
    });
    var vStr = response.body;
    SystemManager.showLog("Get Token", vStr);
    var obj=json.decode(vStr);
    if(obj!=null&&obj['api']!=null&&obj["status"=="1"]){
//      apiUrl=obj['api'];
      boo=true;
    }
    print("get_Server...");
    return boo;
  }

  //1.获取Token
  Future<bool> getToken() async {
    print("CODE:${Manager.instance.hashCode}");
    print("请求token");
    var url = "${this.apiUrl}/token";
    print(url);
    Http.Response response = await Http.post(url, body: {
      'grant_type': 'client_credentials',
      'client_secret': '123456',
      'client_id': 'dfd6150e6de146b84effd255d60e033a'
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    String vStr = response.body;
    var listS = json.decode(vStr);
    if (listS['access_token'] != null) {
      this.token = "Bearer " + listS['access_token'];
      return true;
    }
    SystemManager.showLog("Get Token", this.token);
    return false;
  }

  //2.得到版本号
//  Future<bool> getVersion() async {
//    var url = "${this.apiUrl}/sys/getversion";
//    Http.Response response = await Http.get(url, headers: {
//      'Content-Type': 'application/x-www-form-urlencoded',
//      'Authorization': this.token
//    });
//    String vStr = response.body;
//    SystemManager.showLog("Get Version", vStr);
//    try {
//      var listS = json.decode(vStr);
//      if (listS['data'] != null) {
//        var obj = listS['data'];
//        versionModel = new VersionModel(
//            status: listS['status'],
//            message: listS['message'],
//            data: new VersionData(
//                name: obj['name'],
//                memark: obj['memark'],
//                versionCode: obj['versionCode'],
//                version: obj['version'],
//                url: obj['url']));
//        return true;
//      }
//    } catch (e) {}
//    return false;
//  }

  //3.得到speedtestsetting　??
//  getspeedtestsetting() async {
//    var url = "${this.apiUrl}/sys/getspeedtestsetting";
//    Http.Response response = await Http.get(url, headers: {
//      'Content-Type': 'application/x-www-form-urlencoded',
//      'Authorization': this.token
//    });
//    String vStr = response.body;
//    SystemManager.showLog("Get speedtestsetting", vStr);
//    return true;
//  }

  //4.获取资源路径
//  Future<bool> getCdn() async {
//    var mod = await SystemManager.instance.getModel();
//    var version =versionModel!=null?versionModel.data.version:"1.0.0";
//    var systeminfo = '';
//    var systemversion = "";
//    var systemmodel = "";
//    var devicebrand = "";
//    var language = "";
//    if (mod != null) {
//      systeminfo = mod.host;
//      systemversion = mod.version.release;
//      systemmodel = mod.model;
//      devicebrand = mod.brand;
//    }
//
//    var url =
//        "${this.apiUrl}/sys/getcnd?version=${version}&systeminfo=${systeminfo}&systemversion=${systemversion}&systemmodel=${systemmodel}&devicebrand=${devicebrand}&language=${language}";
//    Http.Response response = await Http.get(url, headers: {
//      'Content-Type': 'application/x-www-form-urlencoded',
//      'Authorization': this.token
//    });
//    String vStr = response.body;
//    SystemManager.showLog("Get Cdn资源路径", vStr);
//    try {
//      var listS = json.decode(vStr);
//      // apiUrl=listS['api']+"/api/v1";
//      resUrl = listS['res'];
//      videoUrl = listS['viedo'];
//      return true;
//    } catch (e) {}
//    return false;
//  }
//
//  热门
//  var hotPageIndex = 1;
//  var hotMaxPageIndex = 100;
//  List<VideoModel> hotVideos = [];
//
//  //最新
//  var newsPageIndex = 2;
//  var newsMaxPageIndex = 100;
//  List<VideoModel> newsVideos = [];
//


//  请求ULR：http://128.14.30.138:83/api/v1/movie/getMoveTop
//  flutter: TOKEN:Bearer CfaDbWliGQIkkgqefwdYHntiLpBOfm93G54ZQO2QXf8P7rU2GM1mS3AsqyzUeq5w
//  V6YomXa7Tuzfjai5KFLRAx6ReFJfMeVq-26Gt7iFXSyxdG1i8tiLpv7FEPI1TPWWwgRqk-4hEhyzEwtzW5X_wWvosgw_bnsLRbL1ROu3S9tKyj9pvVhxnWu0bVnII2q5To1dvdDsg-yAhQ9Ox85YWaf-xpvrVcHnatcwTSMxraE1gzEaZgUxn5qmWm7SXtGM

//  //5.获取影片列表 getMovieTop
  Future<List<VideoModel>> getMovieTop(pageIndex) async {
    print("CODE:${Manager.instance.hashCode}");
    var url = "${this.apiUrl}/movie/getMoveTop";
    Http.Response response = await Http.post(url, body: {
      'PageIndex': "${pageIndex}"
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    print("请求ULR：${url}");
    print("TOKEN:${this.token}");
    String vStr = response.body;
    var listS = json.decode(vStr);
    SystemManager.showLog("Get MovieTop影片信息", vStr);
    if (listS['data'] == null || listS['data'].length <= 0) {
      return [];
    }
    List<VideoModel> ms = VideoModel.fromJson(listS['data']['list']);
    return ms;
  }

  //获取影片信息
  Future<VideoDetailModel> getDetail(shortId) async {
    print("CODE:${Manager.instance.hashCode}");
    var url = "${this.apiUrl}/movie/detail";
    Http.Response response = await Http.post(url, body: {
      'shortId': "${shortId}"
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    var listS = json.decode(vStr);
    SystemManager.showLog("Get Detail影片详情", listS);
    var obj = listS['data'];
    if (obj == null) {
      return null;
    }
    List<ActorerModel> actorerModels = ActorerModel.fromJson(obj['actorer']);
    List<Genre> genres = Genre.fromJson(obj['genres']);
    var videoDetailModel = VideoDetailModel(
        title: obj['title'],
        m3u8: obj['m3u8'],
        videoUrl: obj['videoUrl'],
        actorer: actorerModels,
        thumbHigh:obj['thumbHigh'],// (==""||obj['thumbHight']==null||obj['thumbHight']=="null")?"":obj['thumbHight'],
        genres: genres);
    return videoDetailModel;
  }

  //得到热门、最新
  Future<List<VideoModel>> getMoveMode(var key,pageIndex) async {
    print("CODE:${Manager.instance.hashCode}");
    var url = "${this.apiUrl}/movie/getMoveMode";
    Http.Response response = await Http.post(url, body: {
      'PageIndex': "${pageIndex}",
      "key":"${key}"
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });

    print("请求ULR：${url}");
    print("TOKEN:${this.token}");


    String vStr = response.body;
    var listS = json.decode(vStr);
    SystemManager.showLog("Get MoveMode影片信息", vStr);
    if (listS['data'] == null || listS['data'].length <= 0) {
      return [];
    }
    List<VideoModel> ms = VideoModel.fromJson(listS['data']['list']);
    return ms;
  }

  //得到分类信息
  Future<List<TypeModel>> getCategoryAll() async {
    var url = "${this.apiUrl}/category/getCategoryAll";
    Http.Response response = await Http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    var listS = json.decode(vStr);
    SystemManager.showLog("Get CategoryAll分类信息", vStr);
    if (listS['data'] == null || listS['data'].length <= 0) {
      return [];
    }
    List<TypeModel> ms = TypeModel.fromJson(listS['data']['list']);
    return ms;
  }

//  Future<List<TypeDetailModel>> getSeries(type, pageIndex) async {
//    var url = "${this.apiUrl}";
//    var bodys;
//    if (type == 0) {
//      bodys = {"PageIndex": "${pageIndex}", "key": ""};
//      url += "/series/getSeries";
//    } else if (type == 1) {
//      bodys = {"PageIndex": "${pageIndex}", "key": "", "kind": "0"};
//      url += "/actor/getActors";
//    } else if (type == 2) {
//      bodys = {};
//      url += "/category/getAvCategoryAll";
//    }
//
//    Http.Response response = await Http.post(url, body: bodys, headers: {
//      'Content-Type': 'application/x-www-form-urlencoded',
//      'Authorization': this.token
//    });
//    String vStr = response.body;
//    var listS = json.decode(vStr);
//    SystemManager.showLog("Get 分类下的小分类列表信息", vStr);
//    if (listS['data'] == null || listS['data'].length <= 0) {
//      return [];
//    }
//    List<TypeDetailModel> ms = TypeDetailModel.fromJson(listS['data']['list']);
//    // seriesList.addAll(ms);
//    return ms;
//  }
//
//  //类型点击后跳转到列表数据
//  Future<List<VideoModel>> getList(type, shortId, pageIndex) async {
//    var bodys = {"PageIndex": "${pageIndex}", "shortId": "${shortId}"};
//    var apiUrl = "";
//    if (type == 0) {
//      //得到系列数据
//      apiUrl = "/movie/getMoveBySeries";
//    } else if (type == 1) {
//      //女优
//      apiUrl = "/movie/getMoveByActor";
//    } else if (type == 2) {
//      //类型
//      apiUrl = "/movie/getMoveByTag";
//    }
//
//    var url = "${this.apiUrl}${apiUrl}";
//    Http.Response response = await Http.post(url, body: bodys, headers: {
//      'Content-Type': 'application/x-www-form-urlencoded',
//      'Authorization': this.token
//    });
//    String vStr = response.body;
//    var listS = json.decode(vStr);
//    SystemManager.showLog("Get List影片列表信息", listS);
//    if (listS['data'] == null || listS['data'].length <= 0) {
//      return [];
//    }
//    List<VideoModel> ms = VideoModel.fromJson(listS['data']['list']);
//    return ms;
//  }

}
