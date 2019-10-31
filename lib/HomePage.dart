import "package:flutter/material.dart";
import "dart:ui";
import 'lispart/ListenBookPage.dart';
import 'lispart/sizeAdapter.dart';
import 'pageRouteChange.dart';
import 'package:csxy/readpart/ReadingMenu.dart';
import 'wordpart/pages/WordPart/BookView.dart';

class HomePage extends StatefulWidget{// 主页面
//  HomePage({this.key});
  Key key = Key("_HomePage_");

  @override
  State<StatefulWidget>createState(){
    return _homePage();
  }
}

class _homePage extends State<HomePage>{
  @override
  Key key;
  _homePage({this.key});
  bool isDay = false;
  static int days=0;
  void initState() {
    // TODO: implement initState
    super.initState();
    days = 0;
  }

  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: isDay ? Color.fromRGBO(125, 163, 206, 1)
            : Color.fromRGBO(30, 62, 98, 1),
        appBar:PreferredSize(
            child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: new GestureDetector(
                    child: new Icon(
                        isDay? Icons.wb_sunny:Icons.brightness_3,
                        color: Color.fromRGBO(246, 190, 77, 1),
                        size: sizeAdapter.adaptbySize(22)),
                    onTap: (){
                      setState(() {
                        isDay = !isDay;
                      });
                    }),
                title: Text("Hola 晨小思!",
                  style: new TextStyle(
                    color: Color.fromRGBO(246, 190, 77, 1),
                    fontSize: sizeAdapter.adaptbySize(14),
                    fontFamily: "PingFang TC",
                  ),
                ),
              ),
            preferredSize: Size.fromHeight(sizeAdapter.adaptbyHeight(28))),
        key : key,
        body : new Container(
          color: isDay ? Color.fromRGBO(125, 163, 206, 1)
              : Color.fromRGBO(30, 62, 98, 1),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  child : new Padding(
                    padding:EdgeInsets.only(bottom: sizeAdapter.adaptbyHeight(10)),
                    child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Column(
    //                      mainAxisAlignment: MainAxisAlignment.start,
    //                      crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              new Container(
                                child: new Padding(
                                    padding: EdgeInsets.only(left: sizeAdapter.adaptbyWid(5),
//                                    bottom: sizeAdapter.adaptbyHeight(100),
                                    top: sizeAdapter.adaptbyHeight(10),
                                    ),
                                    child:Image.asset("images/drawable-xxhdpi/268.png")
                                ),
                                width: sizeAdapter.adaptbyWid(140),
                              ),
                            ],
                          ),// 今日目标
                          new Expanded(
                             child: new GestureDetector(
                                  child:new Container(
    //                              color: Colors.amber,
                                    child:new Stack(
                                          children:<Widget>[
                                          Image.asset("images/drawable-xxhdpi/271.png"),
                                          new Padding(
                                                padding:EdgeInsets.only(
                                                  top: sizeAdapter.adaptbyHeight(40),
                                                  left: sizeAdapter.adaptbyWid(50),
                                                ),
                                                child:new Text(
                                                  (days!=null)?(
                                                  (days<10)?"0"+days.toString():days.toString()):"00",
                                                  style: new TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: sizeAdapter.adaptbyMin(112),
                                                  ),
                                                )
                                                ),
                                          ])
                                  ),
                                 onTap: (){
                                   setState(() {
                                     if(days!=null)
                                       days++;
                                     else
                                       days = 1;
                                   });
                                 })
                            ),
                        ]
                      ))
              ),// 今日目标+打卡天数 row
              new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                        new Container(
//                          color: Colors.red,
                          child: new GestureDetector(
                              behavior: HitTestBehavior.deferToChild,
                              child:Image.asset("images/drawable-xxhdpi/wordbutton.png",
                                  height: sizeAdapter.adaptbyMin(72.0),
//                                  color: Colors.amber,
                              ),
                              onTap: (){
//                              Navigator.push(context, new MaterialPageRoute(
//                                  builder: (context)=>new ListenBookPage()));
                                Navigator.push(context, fadePageRouteBuilder(new BookView()));
                              },
                          ),
                        ),
                        new Container(
      //                          color: Colors.red,
                          child: new GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            child:Image.asset("images/drawable-xxhdpi/listeningbutton.png",
                              height: sizeAdapter.adaptbyMin(72.0),
      //                                  color: Colors.amber,
                            ),
                            onTap: (){
//                              Navigator.push(context, new MaterialPageRoute(
//                                  builder: (context)=>new ListenBookPage()));
                              Navigator.push(context, fadePageRouteBuilder(new ListenBookPage()));
                            },
                          ),
                        ),
                        new Container(
                          //                          color: Colors.red,
                          child: new GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            child:Image.asset("images/drawable-xxhdpi/readingbutton.png",
                              height: sizeAdapter.adaptbyMin(72.0),
                              //                                  color: Colors.amber,
                            ),
                            onTap: (){
//                              Navigator.push(context, new MaterialPageRoute(
//                                  builder: (context)=>new ListenBookPage()));
                                Navigator.push(context, fadePageRouteBuilder(new ReadingMenu()));
                            },
                          ),
                        ),
                  ],
                )
            ],
          ),
        )

    );
  }
}