import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as Http;

import '../models/TypeDetailModel.dart';
import '../models/TypeModel.dart';
import '../models/VersionModel.dart';
import '../models/VideoDetailModel.dart';
import '../models/VideoModel.dart';
import 'SystemManager.dart';

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

  var token =
      "Bearer 0Gn_uArTAgDUmpmZHAYwm60evAbcqT9XkvbGX3qny8xL31WipDOmmja54IWJ71DM0qA586JhHMwfjk6Ry9G0elW1yCmeNBbwAiNr-60Ctob7ru5XHfmXtdkLQsY4rKdqoQqlHIx55duhScqtL0SDkQu_VsRtD_HIeCLoHWziF-xsLf8DMotvSkfNozx6naCITzRnP286bp3pHK0e0LzhsXQ6Gor65JWbgS6bKxMNYYbiLtg6s3xmi5Mb63yxrEaQ";
   var apiUrl = "http://api.1av.co/api/v1";
  //var apiUrl = "http://128.14.30.138:83/api/v1";
  var resUrl = "http://128.14.30.138:83/";
  VersionModel versionModel = null;
  var videoUrl = "https://128.14.30.138:83/";

  //得到服务器api ip
  Future<bool> getServer() async{
    return false;
  }

  //1.获取Token
  Future<bool> getToken() async {
    var url = "${this.apiUrl}/token";
    Http.Response response = await Http.post(url, body: {
      'grant_type': 'client_credentials',
      'client_secret': '123456',
      'client_id': 'dfd6150e6de146b84effd255d60e033a'
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    String vStr = response.body;
    SystemManager.showLog("Get Token", vStr);
    var listS = json.decode(vStr);
    if (listS['access_token'] != null) {
      this.token = "Bearer " + listS['access_token'];
      return true;
    }
    return false;
  }

  //2.得到版本号
  Future<bool> getVersion() async {
    var url = "${this.apiUrl}/sys/getversion";
    Http.Response response = await Http.get(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    SystemManager.showLog("Get Version", vStr);
    try {
      var listS = json.decode(vStr);
      if (listS['data'] != null) {
        var obj = listS['data'];
        versionModel = new VersionModel(
            status: listS['status'],
            message: listS['message'],
            data: new VersionData(
                name: obj['name'],
                memark: obj['memark'],
                versionCode: obj['versionCode'],
                version: obj['version'],
                url: obj['url']));
        return true;
      }
    } catch (e) {}
    return false;
  }

  //3.得到speedtestsetting　??
  getspeedtestsetting() async {
    var url = "${this.apiUrl}/sys/getspeedtestsetting";
    Http.Response response = await Http.get(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    SystemManager.showLog("Get speedtestsetting", vStr);
    return true;
  }

  //4.获取资源路径
  Future<bool> getCdn() async {
    var mod = await SystemManager.instance.getModel();
    var version =versionModel!=null?versionModel.data.version:"1.0.0";
    var systeminfo = '';
    var systemversion = "";
    var systemmodel = "";
    var devicebrand = "";
    var language = "";
    if (mod != null) {
      systeminfo = mod.host;
      systemversion = mod.version.release;
      systemmodel = mod.model;
      devicebrand = mod.brand;
    }

    var url =
        "${this.apiUrl}/sys/getcnd?version=${version}&systeminfo=${systeminfo}&systemversion=${systemversion}&systemmodel=${systemmodel}&devicebrand=${devicebrand}&language=${language}";
    Http.Response response = await Http.get(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    SystemManager.showLog("Get Cdn资源路径", vStr);
    try {
      var listS = json.decode(vStr);
      // apiUrl=listS['api']+"/api/v1";
      resUrl = listS['res'];
      videoUrl = listS['viedo'];
      return true;
    } catch (e) {}
    return false;
  }

  //热门
  var hotPageIndex = 1;
  var hotMaxPageIndex = 100;
  List<VideoModel> hotVideos = [];

  //最新
  var newsPageIndex = 2;
  var newsMaxPageIndex = 100;
  List<VideoModel> newsVideos = [];

  //5.获取影片列表 getMovieTop
  Future<List<VideoModel>> getMovieTop(pageIndex) async {
    var url = "${this.apiUrl}/movie/getMoveTop";
    Http.Response response = await Http.post(url, body: {
      'PageIndex': "${pageIndex}"
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    var listS = json.decode(vStr);
    SystemManager.showLog("Get MovieTop影片信息", vStr);
    if (listS['data'] == null || listS['data'].length <= 0) {
      return [];
    }
    List<VideoModel> ms = VideoModel.fromJson(listS['data']['list']);
    return ms;
  }

  Future<VideoDetailModel> getDetail(shortId) async {
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
        genres: genres);
    return videoDetailModel;
  }

  Future<List<VideoModel>> getMoveMode(var key,pageIndex) async {
    var url = "${this.apiUrl}/movie/getMoveMode";
    Http.Response response = await Http.post(url, body: {
      'PageIndex': "${pageIndex}",
      "key":"${key}"
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
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

  Future<List<TypeDetailModel>> getSeries(type, pageIndex) async {
    var url = "${this.apiUrl}";
    var bodys;
    if (type == 0) {
      bodys = {"PageIndex": "${pageIndex}", "key": ""};
      url += "/series/getSeries";
    } else if (type == 1) {
      bodys = {"PageIndex": "${pageIndex}", "key": "", "kind": "0"};
      url += "/actor/getActors";
    } else if (type == 2) {
      bodys = {};
      url += "/category/getAvCategoryAll";
    }

    Http.Response response = await Http.post(url, body: bodys, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    var listS = json.decode(vStr);
    SystemManager.showLog("Get 分类下的小分类列表信息", vStr);
    if (listS['data'] == null || listS['data'].length <= 0) {
      return [];
    }
    List<TypeDetailModel> ms = TypeDetailModel.fromJson(listS['data']['list']);
    // seriesList.addAll(ms);
    return ms;
  }

  //类型点击后跳转到列表数据
  Future<List<VideoModel>> getList(type, shortId, pageIndex) async {
    var bodys = {"PageIndex": "${pageIndex}", "shortId": "${shortId}"};
    var apiUrl = "";
    if (type == 0) {
      //得到系列数据
      apiUrl = "/movie/getMoveBySeries";
    } else if (type == 1) {
      //女优
      apiUrl = "/movie/getMoveByActor";
    } else if (type == 2) {
      //类型
      apiUrl = "/movie/getMoveByTag";
    }

    var url = "${this.apiUrl}${apiUrl}";
    Http.Response response = await Http.post(url, body: bodys, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': this.token
    });
    String vStr = response.body;
    var listS = json.decode(vStr);
    SystemManager.showLog("Get List影片列表信息", listS);
    if (listS['data'] == null || listS['data'].length <= 0) {
      return [];
    }
    List<VideoModel> ms = VideoModel.fromJson(listS['data']['list']);
    return ms;
  }
}
