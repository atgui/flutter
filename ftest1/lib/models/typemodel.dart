class TypeModel {
  var resPath; //图片路径
  var name; //类型名称
  var modelKind; //ID
  var classID; //??

  TypeModel({this.resPath,this.name,this.modelKind,this.classID});

  @override
  toString(){
    return "[name=${this.name},modelKind=${this.modelKind},classID=${this.classID},resPath=${this.resPath}]";
  }

  static List<TypeModel> fromJson(List json){
    if(json==null||json.length<=0){
      return [];
    }
    return json.map((string) => new TypeModel(
        name: string['name'],
        resPath: string['resPath'],
        classID: string['classID'],
        modelKind: string['modelKind']
    )).toList();
  }
}
