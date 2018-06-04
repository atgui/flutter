import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';

//import 'package:device_info/device_info.dart';

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
//  Future getModel() async{
//    var mod=null;
//    if(Platform.isAndroid==true){
//      await DeviceInfoPlugin().androidInfo.then((t){
//        mod= t;
//      });
//    }
//    return mod;
//  }

  static String getIosVersion(){
    return "";
  }

  static String systemOs(){
    return Platform.isAndroid==true?"Android":"IOS";
  }
  static showLog(String title,msg){
    print("================== ${title.length<=0?'START':title} ====================");
    print(msg);
    print("================== END ====================");
  }

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<Map<String, dynamic>> initPlatformState() async {
    Map<String, dynamic> deviceData;
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    }catch(e){}
    print(deviceData);
  return deviceData;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }


}