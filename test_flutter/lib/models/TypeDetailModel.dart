class TypeDetailModel{
  var name;
  var shortId;
  var imgPath;

  TypeDetailModel({this.name,this.imgPath,this.shortId});

  @override
  toString(){
    return "[name=${this.name},shortId=${this.shortId},imgPath=${this.imgPath}]";
  }

  static List<TypeDetailModel> fromJson(List json){
    if(json==null||json.length<=0){
      return [];
    }
    return json.map((string) => new TypeDetailModel(
      name: string['name'],
      imgPath: string['imgPath']!=null?string['imgPath']:"",
      shortId: string['shortId']
      )).toList();
  }

}

class PageCount{
  var pageCont;
}