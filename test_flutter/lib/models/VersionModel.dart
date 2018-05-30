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

  VersionData({this.version,this.memark,this.url,this.versionCode,this.name});
}