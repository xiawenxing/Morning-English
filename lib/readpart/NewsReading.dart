import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csxy/readpart/readglobal.dart' as Globals;
import 'package:csxy/readpart/ReadingDetails.dart';

//this is for the book view actually
class NewsReading extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>new _NewsReadingState();

}
List<Widget> widgetList=new List();

class _NewsReadingState extends State<NewsReading>{

  @override
  Widget build(BuildContext context) {

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: Text('阅读部分', style: new TextStyle(color: Color(0xFF1E3E62), fontSize: 18),),
          leading:Builder(
            builder:(BuildContext context){
              return new IconButton(
//                icon: new Image.asset("pictures/homebackicon.png"),
                icon: new Icon(Icons.backspace),
                color: new Color(0xFF7DA3CE),
                onPressed: () {
                  Navigator.pop(context);
                },); //add onPress later
            },
          ),
        bottom: new TabBar(
            indicatorColor: Color(0xFFF6BE4D),
            indicatorWeight: 5,
            labelColor: Color(0xFF1E3E62),
            tabs: <Widget>[
              new Tab(text: "新闻阅读",),
              new Tab(text: "美文欣赏",),
//              new Tab(icon: new Icon(Icons.directions_bus),),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Center(
                  child: new Container(
                    decoration:new BoxDecoration(
                      color: Color(0xFFEFF5FC),
                    ),
                    child: new ListView(
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            Globals.showingNews = Globals.NewsExample.first;
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>ReadingDetails())
                            );
                          },
                          child: Column(
                            mainAxisSize:MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(top: 30.0, left: 26.0, right: 26.0, bottom: 10),
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
                                        margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 10.0),
                                        alignment: Alignment.topLeft,
                                        child: Text( //卡片文字
                                          Globals.NewsExample[0].newsTitle.toString(),
                                          maxLines: 1,
                                          style: TextStyle(color: Color.fromRGBO(30, 62, 98, 1), fontSize: 18.0, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),

                                      new Container(
                                        margin: EdgeInsets.only(top: 5.0, left: 30.0, right: 10.0),
                                        alignment: Alignment.topLeft,
                                        child: Text( //卡片文字
                                          Globals.NewsExample[0].shortIntroduction.toString(),
                                          maxLines: 2,
                                          style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1), fontSize: 14.0),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),


                        new Container(
//              decoration:new BoxDecoration(
//                color: Color(0xFFEFF5FC),
//              ),
                          margin: EdgeInsets.all(0.0),
                          height: MediaQuery.of(super.context).size.width / 2.8 * (Globals.NewsExample.length-1),
                          child:new GridView.count(
                            physics: new NeverScrollableScrollPhysics(),
                            padding:const EdgeInsets.all(0),
                            childAspectRatio: 2.8,
                            crossAxisCount: 1,
                            children:_NewsList(),
                          ),
                        ),
                      ],
                    ),
                  )
              ),

            new Center(
                child: new Container(
                  decoration:new BoxDecoration(
                    color: Color(0xFFEFF5FC),
                  ),
                  child: new ListView(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          Globals.showingNews = Globals.NewsExample.first;
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>ReadingDetails())
                          );
                        },
                        child: Column(
                          mainAxisSize:MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(top: 30.0, left: 26.0, right: 26.0, bottom: 10),
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
                                      margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 10.0),
                                      alignment: Alignment.topLeft,
                                      child: Text( //卡片文字
                                        Globals.NewsExample[0].newsTitle.toString(),
                                        maxLines: 1,
                                        style: TextStyle(color: Color.fromRGBO(30, 62, 98, 1), fontSize: 18.0, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                    new Container(
                                      margin: EdgeInsets.only(top: 5.0, left: 30.0, right: 10.0),
                                      alignment: Alignment.topLeft,
                                      child: Text( //卡片文字
                                        Globals.NewsExample[0].shortIntroduction.toString(),
                                        maxLines: 2,
                                        style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1), fontSize: 14.0),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ),


                      new Container(
//              decoration:new BoxDecoration(
//                color: Color(0xFFEFF5FC),
//              ),
                        margin: EdgeInsets.all(0.0),
                        height: MediaQuery.of(super.context).size.width / 2.8 * (Globals.NewsExample.length-1),
                        child:new GridView.count(
                          physics: new NeverScrollableScrollPhysics(),
                          padding:const EdgeInsets.all(0),
                          childAspectRatio: 2.8,
                          crossAxisCount: 1,
                          children:_NewsList(),
                        ),
                      ),
                    ],
                  ),
                )
            ),
//            new Center(child: new Text('巴士')),
          ],
        ),
      ),
    );

  }

  // ignore: unused_element
  List<Widget> _NewsList(){
    List<Widget> widgetList = new List();
    for(int i = 1; i<Globals.NewsExample.length; i++){
      String newsTitle = Globals.NewsExample[i].newsTitle.toString();
      String newsShortIntroduction = Globals.NewsExample[i].shortIntroduction.toString();
        widgetList.add(FlatButton(onPressed: (){
          Globals.showingNews = Globals.NewsExample[i];
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>ReadingDetails())
          );
        },
            child:Column(
              mainAxisSize:MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                  constraints: BoxConstraints.tightFor(height: 115.0),
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

                  child: Row(
                      children:[
                        new Column(
                          children: <Widget>[

                            new Container(
                              margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 0.0),
                              alignment: Alignment.topLeft,
                              width: MediaQuery.of(super.context).size.width / 4 * 2.2,
                              child: new Text( //卡片文字
                                newsTitle,
                                maxLines: 2,
                                style: TextStyle(color: Color.fromRGBO(30, 62, 98, 1), fontSize: 16.0, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            new Container(
                              margin: EdgeInsets.only(top: 5.0, left: 15.0, right: 0.0),
                              width: MediaQuery.of(super.context).size.width / 4 * 2.2,
                              child: new Text( //卡片文字
                                newsShortIntroduction,
                                style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1), fontSize: 14.0),
                                textAlign: TextAlign.left,
                                maxLines: 3,
                              ),
                            ),

                          ],
                        ),

                        new Container(
                          alignment: Alignment.center,
                          child: new ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: new Image.asset(
                              'images/readingMenu2.png',
                              width: MediaQuery.of(super.context).size.width / 4 > 90 ? 90 : MediaQuery.of(super.context).size.width / 4,
                              fit: BoxFit.fitHeight,
                              height: MediaQuery.of(super.context).size.width / 4 > 90 ? 90 : MediaQuery.of(super.context).size.width / 4,
                            ),
                          ),
                        ),


                      ]
                  ),
                ),
              ],
          )));
      }
    return widgetList;
  }
}