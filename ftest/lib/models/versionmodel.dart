class VersionModel{
  var status;
  var message;
  VersionData data;
  VersionModel({this.status,this.message,this.data});
}
class VersionData{
  var version;
  var memark;
  var url;
  var versionCode;
  var name;
  VersionData({this.version,this.versionCode,this.url,this.name,this.memark});
}

class SystemModel{
  var host;
  var release;
  var model;
  var brand;

  SystemModel({this.host,this.release,this.model,this.brand});
}