import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csxy/readpart/readglobal.dart' as Globals;
import 'package:csxy/readpart/ReadingBank.dart';
import 'package:csxy/readpart/NewsReading.dart';


//this is for the book view actually
class ReadingMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>new _NewsViewState();
}

class _NewsViewState extends State<ReadingMenu>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('阅读部分', style: new TextStyle(color: new Color(0xFF1E3E62), fontSize: 18),),
          elevation: 0.5,
          flexibleSpace: Container(color:Colors.white),
          leading:Builder(
            builder:(BuildContext context){
              return new IconButton(
//                icon: new Image.asset("pictures/homebackicon.png"),
                icon: new Icon(Icons.home),
                color: new Color(0xFF7DA3CE),
                onPressed: () {
                  Navigator.pop(context);
              },); //add onPress later
            },
          ),
        ),
        body: new Container(
          decoration:new BoxDecoration(
            color: Color(0xFFEFF5FC),
          ),
          child:
          ListView(
            children:<Widget>[

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>NewsReading())
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
                  constraints: BoxConstraints.tightFor(height: 220.0),
                  decoration: BoxDecoration(//背景装饰
                      gradient: RadialGradient( //背景径向渐变
                          colors: [Colors.white, Colors.white],
                          center: Alignment.topLeft,
                          radius: .98
                      ),
                      borderRadius: new BorderRadius.all(Radius.circular(15.0)),

                      boxShadow: [ //卡片阴影
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 8.0,
                        )
                      ]
                  ),

                  child: Column(
                      children:[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: new Image.asset(
                            'images/readingMenu1.jpg',
                            width: MediaQuery.of(super.context).size.width,
                            fit: BoxFit.fitWidth,
                            height: 140,
                          ),
                        ),

                        new Container(
                          margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 0.0),
                          alignment: Alignment.topLeft,
                          child: Text( //卡片文字
                            "新闻阅读与美文赏析",
                            style: TextStyle(color: Color.fromRGBO(30, 62, 98, 1), fontSize: 18.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        new Container(
                          margin: EdgeInsets.only(top: 5.0, left: 30.0, right: 0.0),
                          alignment: Alignment.topLeft,
                          child: Text( //卡片文字
                            "每天一篇时事热点与最新西语文学",
                            style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1), fontSize: 14.0),
                            textAlign: TextAlign.left,
                          ),
                        ),

                      ]
                  ),

//                Column (
//                  children:[
//                    Image.asset('pictures/readbutton.png', height: 100, width: , fit: BoxFit.fitWidth,),
//                    Text("hello"),
//                  ]
//              )
                ),
              ),

              GestureDetector(
                onTap: () {
                  print(Globals.newArticle);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>ReadingBank())
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
                  constraints: BoxConstraints.tightFor(height: 220.0),
                  decoration: BoxDecoration(//背景装饰
                      gradient: RadialGradient( //背景径向渐变
                          colors: [Colors.white, Colors.white],
                          center: Alignment.topLeft,
                          radius: .98
                      ),
                      borderRadius: new BorderRadius.all(Radius.circular(15.0)),

                      boxShadow: [ //卡片阴影
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 8.0,
                        )
                      ]
                  ),

                  child: Column(
                      children:[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: new Image.asset(
                            'images/readingMenu2.png',
                            width: MediaQuery.of(super.context).size.width,
                            fit: BoxFit.fitWidth,
                            height: 140,
                          ),
                        ),

                        new Container(
                          margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 0.0),
                          alignment: Alignment.topLeft,
                          child: Text( //卡片文字
                            "阅读题库",
                            style: TextStyle(color: Color.fromRGBO(30, 62, 98, 1), fontSize: 18.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        new Container(
                          margin: EdgeInsets.only(top: 5.0, left: 30.0, right: 0.0),
                          alignment: Alignment.topLeft,
                          child: Text( //卡片文字
                            "西语等级考试全套真题放送",
                            style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1), fontSize: 14.0),
                            textAlign: TextAlign.left,
                          ),
                        ),

                      ]
                  ),

//                Column (
//                  children:[
//                    Image.asset('pictures/readbutton.png', height: 100, width: , fit: BoxFit.fitWidth,),
//                    Text("hello"),
//                  ]
//              )
                ),
              ),



            ],

          ),
        ),
      );
  }
}

Widget _buildButtonColumn(BuildContext context,String img){
  return Container(
    margin:const EdgeInsets.only(top:0, left: 0, right: 0, bottom: 0),
    child:
    Column(
        mainAxisSize:MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget>[
          Image.asset(img, fit: BoxFit.fitHeight,),
        ]
    ),
  );
}