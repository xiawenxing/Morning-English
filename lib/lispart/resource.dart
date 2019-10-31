import "package:flutter/material.dart";
import "dart:ui";
import 'listensrcDB.dart';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "dart:io";

/*
* 听力资源的数据结构
* */
class FetchSrc{// 听力资源的获取
  // 如果本地数据库已经有了，直接从本地获取
  // 如果本地数据库还没有，使用DownloadSrc从leancloud下载（并同时更新本地数据库）
  String bookname;
  String errormsg = "";
  DownloadSrc _downloadSrc;
  ListenBookDB _listenBookDB;
  FetchSrc(String name) {
    bookname = name;
    _listenBookDB = new ListenBookDB();
  }

  void fetchsrc() async{
    int bookid = int.parse(bookname.substring(10)) - 1;

    if(ListenBookDB.isdownloaded==null||_listenBookDB.isBookDownDB(bookid)==false){
      // 本地数据库还没有，使用DownloadSrc从leancloud下载（并同时更新本地数据库）
      _downloadSrc = new DownloadSrc(bookname);
      await _downloadSrc.DownBook();
      errormsg = _downloadSrc.errormsg;
      print(errormsg);
    }else if(_listenBookDB.isBookDownDB(bookid)==true)
    {// 本地数据库已经有了，直接从本地获取
      print("从数据库加载");
      await _listenBookDB.opendb();

      try{
        List<Map> maplist = await _listenBookDB.queryrowAll(bookname);
        if(maplist==null || maplist.length==0){
          errormsg = "该内容还未上线，敬请期待...";
        }else{
          ListenBookList.booklist[bookid].fromMapList(maplist);
//          ListenBookList.booklist[bookid].partnum = ListenBookList.booklist[bookid].book.length;
          ListenBookList.bookisdown[bookid] = true;
        }
      }catch(e){
        print(e);
        if(e.toString().contains("no such table")){
          errormsg = "该内容还未上线，敬请期待...";
        }else{
          errormsg = "本地资源加载出错...";
        }
      }
    }

    await _listenBookDB.closedb();

    await ListenBookList.booklist[bookid].book.sort(
        (ListenResource a,ListenResource b)=>a.partid.compareTo(b.partid)
    );
  }
}


class DownloadSrc{// 听力资源下载  下载到static数据中
  static LeancloudFlutterPlugin _leancloudFlutterPlugin = LeancloudFlutterPlugin.getInstance();
  ListenBookDB _listenBookDB;
  List<ListenResource> Book;
  String bookname;
  String errormsg = "";

  void initial() async{
    await init();
  }

  void init() {
    // zyhz
    //  String appId = "EovsOGWqLF2GjebRb75WVBqJ-MdYXbMMI";
    //  String appKey = "XVhCoNOYsBimajcg4RIz9qKb";
    // yjx
    String appId = "QAWcNjepPy81eAAoSKGwIgvW-gzGzoHsz";
    String appKey = "Ac3XvwgKKSDnbfF29D8zn3tk";
    _leancloudFlutterPlugin.setLogLevel(LeancloudLoggerLevel.DEBUG);
    _leancloudFlutterPlugin.initialize(appId, appKey);
    // sqftile
    // sharedpreference
  }

  DownloadSrc(String name){
    this.bookname = name;
    _listenBookDB = new ListenBookDB();
    initial();
  }
  
  Future<bool> DownBook() async{
    if(bookname.substring(0,10)=="ListenBook") {
      // 下载到static中
      int bookid = int.parse(bookname.substring(10)) - 1;
      if (ListenBookList.bookisdown[bookid]==false) {
        print("Start download"+bookname);
        ListenBookList.booklist[bookid].book = List<ListenResource>();
        AVQuery avquery = new AVQuery(bookname);
        try{
          avquery.whereNotEqualTo("name", "null");
          await avquery.find().then((parts) {
            parts.forEach((item) {
              ListenBookList.booklist[bookid].book.add( new ListenResource(
                (item.get("name")).toString(),
                ((item.get("audio"))["serverData"]["url"]).toString(),
                ((item.get("docfile"))["serverData"]["url"]).toString(),
                bookid
              ));
//            print("downloading "+item.get("name")+"from"+((item.get("audio"))["serverData"]["url"]).toString());
            });
          });
          ListenBookList.bookisdown[bookid] = true;
          ListenBookList.booklist[bookid].partnum = ListenBookList.booklist[bookid].book.length;

        }catch(e){
          ListenBookList.bookisdown[bookid] = false;
          ListenBookList.booklist[bookid].partnum = -1;
          print(e.toString());
          if(e.toString().contains("doesn't exists")){
            errormsg = "该内容还未上线，敬请期待...";
            _listenBookDB.setDownloadTrue(bookid);
          }else if(e.toString().contains("(error, length=0;"))
          {
            errormsg = "连接出现问题,请重试...";
            _leancloudFlutterPlugin = LeancloudFlutterPlugin.getInstance();
            initial();
          }
        }

        await _listenBookDB.opendb();
        try{
          await _listenBookDB.createTable(bookname); // 在数据库中建表
          // 储存到本地数据库
          for(int i=0; i<ListenBookList.booklist[bookid].book.length; i++){
            print("adding");
            await _listenBookDB.addrow(bookname, ListenBookList.booklist[bookid].book[i]);
          }
          await _listenBookDB.setDownloadTrue(bookid);
        }catch(e){
          print(e.toString());
        }
        _listenBookDB.closedb();
    }

      }
    }
}

class ListenBookList{// 数据：听力书信息
  static const int booknum = 4;
  static const List<String> booknames_ch = ["现代西班牙1","现代西班牙2","现代西班牙3", "现代西班牙4"];
  static const List<String> booknames_en = ["ListenBook1","ListenBook2","ListenBook3", "ListenBook4"];
  static List<ListenBook> booklist = [new ListenBook(0), new ListenBook(1), new ListenBook(2), new ListenBook(3)];
  static List<bool> bookisdown = [false, false, false, false];
//  static const List<int> bookpartnum = [7,13,16,16] ;
//  static List<int> bookpartstart = [10,1,1,1];
}

class ListenBook{
  int partnum;
  int bookid;
  List<ListenResource> book;

  ListenBook(int id){
    book = List<ListenResource>();
    bookid = id;
  }

  void fromMapList(List<Map> maplist){
    book = List<ListenResource>();
    for(int i=0; i<maplist.length; i++)
      {
        book.add(new ListenResource("","","",bookid));
        book[i].fromMap(maplist[i]);
      }
    partnum = maplist.length;
  }
}

class ListenResource{// 数据：听力资源对象（标题、文章路径、音源路径）
  int bookid;
  int partid;
  String title;
  String audiourl;
  String fileurl;
  String audioLocalurl;
  String fileLocalurl;
  ListenResource(String title, String audiourl, String fileurl, int bookid){
    this.title = title;
    this.audiourl = audiourl;
    this.fileurl = fileurl;
    this.bookid = bookid;
    if(title.contains("unidad"))
      {
        partid = int.parse(title.substring(7));
      }
  } //this.content, this.pathname, this.audio_path);

  Map<String, dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map['name'] = title;
    map['audiourl'] = audiourl;
    map['fileurl'] = fileurl;
    map['audioLocalurl'] = audioLocalurl;
    map['fileLocalurl'] = fileLocalurl;

    return map;
  }

  void fromMap(Map<String,dynamic> map){
    title = map['name'];
    audiourl = map['audiourl'];
    fileurl = map['fileurl'];
    audioLocalurl = map['audioLocalurl'];
    fileLocalurl = map['fileLocalurl'];
    if(title.contains("unidad"))
    {
      partid = int.parse(title.substring(7));
    }
  }
}
