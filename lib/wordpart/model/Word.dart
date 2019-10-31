

class Word{

  int Id;
  String Spanish;
  String Type;
  String Chinese;

  Word(this.Id,this.Spanish,this.Type,this.Chinese);
  //Word();
  Word.map(dynamic obj){
    this.Id=obj['Id'];
    this.Spanish=obj['Spanish'];
    this.Type=obj['Type'];
    this.Chinese=obj['Chinese'];
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    if(Id!=null){
      map['Id']=Id;
    }
    map['Spanish']=Spanish;
    map['Type']=Type;
    map['Chinese']=Chinese;
    return map;
  }
  Word.fromMap(Map<String,dynamic>map){
    this.Id=map['Id'];
    this.Spanish=map['Spanish'];
    this.Type=map['Type'];
    this.Chinese=map['Chinese'];
  }

}