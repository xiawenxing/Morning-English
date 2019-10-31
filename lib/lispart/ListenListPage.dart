import "package:flutter/material.dart";
import "dart:ui";
import "PlayPage.dart";
import "resource.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'sizeAdapter.dart';
import 'package:csxy/pageRouteChange.dart';
import 'listenTapbar.dart';
import 'listensrcDB.dart';

/*
*  显示听力列表的界面，需要调用一个list组件
* */
class ListenPage extends StatefulWidget{
  Key key = Key("_LisList");

  @override
  State<StatefulWidget> createState() => _ListenPage(this.bookid);

  int bookid;
  ListenPage(int index){
    bookid = index;
  }
}

class _ListenPage extends State<ListenPage>{// 听力播放列表页面
  int bookid;
  bool isdown;
  bool isrefreshstart;
  bool isrefreshend;
  String errormsg = "";

  _ListenPage(int id){
    bookid = id;
  }

  Future<void> Downloadbook() async {
    if(ListenBookList.bookisdown[bookid] == false) {
//      DownloadSrc downloader = new DownloadSrc(
//          ListenBookList.booknames_en[bookid]);
//      await downloader.DownBook();
      FetchSrc loader = new FetchSrc( ListenBookList.booknames_en[bookid]);
      await loader.fetchsrc();
      errormsg = loader.errormsg;
      setState(() {
        isdown = true;
      });
//      print("enddownload");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isdown = ListenBookList.bookisdown[bookid];
    Downloadbook();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop:(){
        Navigator.of(context).pop();
      },
      child: Scaffold(
          key: widget.key,
          backgroundColor: Color.fromRGBO(239, 245, 252, 1),// 背景色浅蓝
          appBar: AppBar(
            centerTitle: true,
            title:Text(
              ListenBookList.booknames_ch[bookid],
              style: new TextStyle(
                  color: Color.fromRGBO(30, 62, 98, 1),
                  fontSize: sizeAdapter.adaptbySize(18.0)
              ),
            ),// appbar
            backgroundColor: Colors.white,
            leading: new IconButton(
                  icon: new Icon(Icons.home, color: Color.fromRGBO(30, 62, 98, 1),),
                  onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                         '/home',
                        (route) => route == null
                    );
                  }
                ),
            actions:[
              new PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Color.fromRGBO(30, 62, 98, 1)),
                  itemBuilder: (context)=><PopupMenuEntry<String>>[
                    PopupMenuItem(
                      child: new Container(
                        child:new GestureDetector(
                          child:new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Icon(Icons.sync, color: Color.fromRGBO(30, 62, 98, 1)),
                                  new Text("更新本地资源")
                                ],
                              ),
                          onTap: (){
                            setState(() {
                              isdown = false;
                            });
                            _refreshFromOnline();
                          }),
                      ),
                    )
                  ],
                  offset: Offset(200, 200),
              )
            ],
          ),
          body:Center(// body
            child:
            isdown?(
              ListenBookList.bookisdown[bookid]?
                _ListenList(context, ListenBookList.booklist[bookid]):
                new Text(errormsg, style: new TextStyle(color: Color.fromRGBO(125, 163, 206, 1)))
            ):
              new SpinKitFadingCube(color: Color.fromRGBO(125, 163, 206, 1),
                size: sizeAdapter.adaptbySize(50.0),
                duration: Duration(milliseconds: 2000),)
            ),
      ),
    );
  }

  Widget _ListenList(BuildContext context, ListenBook listenbook){
    return new RefreshIndicator(
        child: ListView.separated(
          itemCount:listenbook.partnum,
          itemBuilder:(context, index){
            return
              ListTile(
                title:Text(listenbook.book[index].title,
                    style:TextStyle(fontSize:sizeAdapter.adaptbySize(15.0),
                        fontWeight: FontWeight.bold, color: Color.fromRGBO(27, 67, 95,1))),
//                subtitle: new Text('...'),
//                leading: new Icon(Icons.image, color: Color.fromRGBO(27, 67, 95,1),),
                trailing: new Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(context, scalePageRouteBuilder(new LisOrTestPage(listenbook.book[index])));
                },
              );// return listtile
            //else return new Divider();
          },
          separatorBuilder: (context, index){
            return Divider(color: Color.fromRGBO(125, 163, 206, 1));
          },
        ),
        color: Color.fromRGBO(125, 163, 206, 1) ,
        onRefresh: _refreshFromDB );
  }

  Future<void> _refreshFromDB() async{
    ListenBookList.bookisdown[bookid] = false;
    FetchSrc loader = new FetchSrc( ListenBookList.booknames_en[bookid]);
    await loader.fetchsrc();
    setState(() {
      isdown = true;
    });
  }

  Future<void> _refreshFromOnline() async{
    ListenBookList.bookisdown[bookid] = false;
    ListenBookDB _lisdb = new ListenBookDB();
    await _lisdb.setDownloadFalse(bookid);
    await Downloadbook();
  }
}

/*
* 听力列表的组件 主要是listview组件来构造
* dismissable来删除
*
class _ListenPageList extends StatelessWidget{// 听力播放列表组件
  final List<ListenResource> listenpages;
  Key key;
  _ListenPageList({this.key, @required this.listenpages, });

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        body: ListView.builder(
            itemCount:listenpages.length,
            itemBuilder:(context, index){
              //if(mode==1)
              return Card( child: ListTile(
                title:Text(listenpages[index].title,style:TextStyle(fontWeight: FontWeight.w500)),
                subtitle: new Text('...'),
                leading: new Icon(Icons.image, color: Color.fromRGBO(27, 67, 95,1),),
                trailing: new Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (_)=>new ListenPlayerPage(resource:listenpages[index])));
                },
              ));// return listtile
              //else return new Divider();
            }
        )
    );
  }
}
*/
