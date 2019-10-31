import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csxy/readpart/readglobal.dart' as Globals;


//this is for the book view actually
class ReadingDetails extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>new _ReadingDetailsState();
}

class _ReadingDetailsState extends State<ReadingDetails>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        flexibleSpace: Container(color:Colors.white),
        leading:Builder(
          builder:(BuildContext context){
            return new IconButton(
//                icon: new Image.asset("pictures/homebackicon.png"),
              icon: new Icon(Icons.backspace),
              color: new Color(0xFF7DA3CE),
              onPressed: () {
                Navigator.pop(context);
              },
            ); //add onPress later
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => print("star"),
            icon: new Icon(Icons.star),
            color: new Color(0xFF7DA3CE),
          ),
          IconButton(
            onPressed: () => print("share"),
            icon: Icon(Icons.share),
            color: new Color(0xFF7DA3CE),
          ),
        ],
      ),
      body: new Container(
        margin: EdgeInsets.only(bottom: 0),
        decoration:new BoxDecoration(
          color: Color(0xFFEFF5FC),
        ),
        child:
        ListView(
          children:<Widget>[
            new Container(
              margin: EdgeInsets.only(top: 30.0, left: 26.0, right: 26.0, bottom: 10),
              child: new Text(
                Globals.showingNews.newsTitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(30, 62, 98, 1), letterSpacing: 0.5, fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
            ),

            new Container(
              margin: EdgeInsets.only(top: 0.0, left: 26.0, right: 26.0, bottom: 10),
              child: new Text(
                Globals.showingNews.chineseName,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(30, 62, 98, 1), letterSpacing: 0.5, fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
            ),

            new Container(
              margin: EdgeInsets.only(top: 0.0, left: 26.0, right: 26.0, bottom: 10),
              child: new Text(
                Globals.showingNews.createTime,
                textAlign: TextAlign.left,
                style: TextStyle(color: Color(0xFF1E3E62), fontSize: 12.0, letterSpacing: 0.5, fontWeight: FontWeight.w200),
              ),
            ),

            new Container(
              margin: EdgeInsets.only(top: 0.0, left: 26.0, right: 26.0, bottom: 10),
              child: new Text(
                '难度: ' + Globals.showingNews.difficulty + '   单词: ' + Globals.showingNews.wordNumbers + '   来源: ' + Globals.showingNews.source,
                textAlign: TextAlign.left,
                style: TextStyle(color: Color(0xFF1E3E62), fontSize: 12.0, letterSpacing: 0.5, fontWeight: FontWeight.w200),
              ),
            ),

            new Container(
              margin: EdgeInsets.only(top: 0.0, left: 26.0, right: 26.0, bottom: 10),
              child: new Text(
                Globals.showingNews.details,
                textAlign: TextAlign.left,
                style: TextStyle(color: Color(0xFF1E3E62), fontSize: 16.0, letterSpacing: 0.5, fontWeight: FontWeight.w300),
              ),
            ),

            new Divider(
              height: 1,
              indent: 60,
              endIndent: 60,
            ),

            new Container(
              margin: EdgeInsets.only(top: 40.0, left: 26.0, right: 26.0, bottom: 0),
              child: new Text(
                '新闻大意',
                textAlign: TextAlign.left,
                style: TextStyle(color: Color(0xFF1E3E62), fontSize: 14.0, letterSpacing: 0.5, fontWeight: FontWeight.w500),
              ),
            ),

            new Container(
              margin: EdgeInsets.only(top: 20.0, left: 26.0, right: 26.0, bottom: 10),
              child: new Text(
                Globals.showingNews.chineseDetails + '\n\n',
                textAlign: TextAlign.left,
                style: TextStyle(color: Color(0xFF1E3E62), fontSize: 14.0, letterSpacing: 0.5, fontWeight: FontWeight.w300),
              ),
            ),

          ],
        ),
      ),


    );
  }
}

