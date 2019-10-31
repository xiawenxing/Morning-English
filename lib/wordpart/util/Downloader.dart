import 'dart:math';

import 'package:csxy/wordpart/model/Word.dart';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import 'package:csxy/wordpart/Globals.dart' as Globals;


class Downloader{
  int TypeMarker;
  String ObjectName;
  int entryNum=0;
  List<Word> lists;

  Downloader(int TypeMarker,String ObjectName){
    this.TypeMarker=TypeMarker;
    this.ObjectName=ObjectName;
  }

  Future<bool> _queryAllWords(String BookName) async{
    lists=new List<Word>();
    //avQuery.limit("1000");
    int Bookid=int.parse(ObjectName.substring(4))-1;
    int TotalNum=Globals.WordNum[Bookid];

    for(int j=0;j<(TotalNum/100).ceil();j++){
      AVQuery avQuery = new AVQuery(ObjectName);
      avQuery.whereGreaterThanOrEqualTo("Id", j*100+1);
      avQuery.whereLessThanOrEqualTo("Id", (j+1)*100);
      await avQuery.find().then((objects) {
        objects.forEach((item) {
          lists.add(new Word(item.get("Id"),pruneWord(item.get("Spanish")),pruneWord(item.get("Type")),pruneWord(item.get("Chinese"))));
        });
      });
    }
    return true;
  }

  String pruneWord(String word){
    if(word==""||word==null){
      return "";
    }
    int index1= word.indexOf(",")==-1?word.length:word.indexOf(",");
    int index2= word.indexOf(";")==-1?word.length:word.indexOf(";");
    //int index3= word.indexOf(" ")==-1?word.length:word.indexOf(" ");
    int index4= word.indexOf("，")==-1?word.length:word.indexOf("，");
    int index5= word.indexOf("；")==-1?word.length:word.indexOf("；");
    int index6= word.indexOf("\n")==-1?word.length:word.indexOf("\n");
    int index7= word.indexOf("\r")==-1?word.length:word.indexOf("\r");
    int index8= word.indexOf("\r\n")==-1?word.length:word.indexOf("\r\n");
    int index9= word.indexOf("-")==-1?word.length:word.indexOf("-");
//      print("index1="+index1.toString()+";index2="+index2.toString()+";index3="+index3.toString()+";index4="+index4.toString());
      //print("After:"+ word.substring(0,min(min(min(min(min(min(min(min(index1,index2),index3),index4),index5),index6),index7),index8),index9)));
//      int minIndex=min(min(index1,index2),index3);
    return  word.substring(0,min(min(min(min(min(min(min(index1,index2),index4),index5),index6),index7),index8),index9));
  }

  //TBD Unavailable
//  _queryByCQL() async {
//    var cql = "select * from "+ObjectName;
//    await AVQuery.doCloudQuery(cql).then((objects) {
//      i=0;
//      objects.forEach((item) {
//        lists.add(new Word(item.get("Id"),pruneWord(1,item.get("Spanish")),item.get("Type"),pruneWord(2,item.get("Chinese"))));
//        i++;
//      });
//      print("All Objects Queryed!");
//    });
//  }

  void DownloadBook() async{
    if(ObjectName.substring(0,4)=="Book"){
      int Bookid=int.parse(ObjectName.substring(4))-1;
      String BookName=Globals.Books.bookNames[Bookid];
      //await _queryByCQL();
      if(Globals.Storage.prefs.getBool('isDownloaded'+(Bookid+1).toString())!=null && Globals.Storage.prefs.getBool('isDownloaded'+(Bookid+1).toString())==false){
        await _queryAllWords(BookName);
        //await _queryByCQL();
        await insertData("Book"+(Bookid+1).toString());
        //Globals.Books.isDownloaded[Bookid]=true;
        await Globals.Storage.prefs..setBool('isDownloaded'+(Bookid+1).toString(),true);
        print("Reset one Book isDownloaded!!!");
      }
    }
  }

  void insertData(String BookName) async{

    for(int j=0;j<lists.length;j++){
      await Globals.DB.WordDB.insert(lists[j],BookName);
      //print(lists[j].Type);
    }
    entryNum=1+await Globals.DB.WordDB.getTotalNum(BookName);
    print("All Objects Inserted!");
  }

  Future<int> Start() async{
    //download the resource
    //insert data into local database...
    switch(TypeMarker){
      case 1://for Word Part
        await DownloadBook();
        print("DownloadBook()");
        return entryNum;
      case 2://for listening part
        return 0;
    }
    return 0;
  }

}