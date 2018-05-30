import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';

// export PUB_HOSTED_URL="https://pub.flutter-io.cn";
// export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn";

class SystemManager {
  static SystemManager _singleton = null;
  static SystemManager get instance {
    if (_singleton == null) {
      _singleton = new SystemManager();
    }
    return _singleton;
  }
  Future getModel() async{
    var mod=null;
    if(Platform.isAndroid==true){
      await DeviceInfoPlugin().androidInfo.then((t){
        mod= t;
      });
    }
    return mod;
  }


  static showLog(String title,msg){
    print("================== ${title.length<=0?'START':title} ====================");
    print(msg);
    print("================== END ====================");
  }

}