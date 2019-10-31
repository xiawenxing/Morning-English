import "package:flutter/material.dart";
import "dart:ui";
import "resource.dart";
import 'ListenListPage.dart';
import 'sizeAdapter.dart';
import 'package:csxy/pageRouteChange.dart';

class ListenBookPage extends StatelessWidget{
  Key key = Key("_lisbook_");

  List<Image> bookimages = [
    Image.asset("images/drawable-xxhdpi/p1.png",fit: BoxFit.cover,),
    Image.asset("images/drawable-xxhdpi/p22.png", fit: BoxFit.cover,),
    Image.asset("images/drawable-xxhdpi/p2.png", fit: BoxFit.cover,),
    Image.asset("images/drawable-xxhdpi/p29.png", fit: BoxFit.cover,),
  ];

  @override
  Widget build(BuildContext context){
    return WillPopScope(
        onWillPop:(){
          Navigator.of(context).pop();
        },
        child:Scaffold(
          key: key,
          backgroundColor: Color.fromRGBO(239, 245, 252, 1),//背景颜色
          appBar: AppBar(
            title:Text("听力训练",
                style: new TextStyle(
                    fontSize:sizeAdapter.adaptbySize(18.0) ,
                    color: Color.fromRGBO(30, 62, 98, 1)
                )
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color:  Color.fromRGBO(30, 62, 98, 1)),
            elevation: 3.0,
            leading: new IconButton(icon: new Icon(Icons.home),
                onPressed: (){
                Navigator.of(context).pop();
            }),
          ),// appbar
          body: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              new Padding(
                padding: EdgeInsets.only(
                    top: sizeAdapter.adaptbyHeight(10.0),
                    left: sizeAdapter.adaptbyWid(5.0),
                    right: sizeAdapter.adaptbyWid(5.0),
                    bottom: sizeAdapter.adaptbyHeight(10.0)),
                child: Image.asset("images/drawable-xxhdpi/listenbooklistpic.png"),
              ),// picture
              Expanded(
                child : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: sizeAdapter.adaptbyHeight(10),
                      crossAxisSpacing: sizeAdapter.adaptbyWid(10),
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index){
                      return new InkWell(
                        onTap:(){
                          Navigator.push(context, slidePageRouteBuilder(new ListenPage(index)));
                        },
                        child:
                        new Column(
                            children:<Widget>[
                                new Stack(
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:new Container(
                                          child: bookimages[index%4],
                                          width: sizeAdapter.adaptbyWid(95),
                                          height: sizeAdapter.adaptbyWid(95),
                                      )
                                    ),
                                    new ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: new Container(
                                          color:Colors.white.withOpacity(0.2),
                                          child:  Icon(Icons.headset,
                                                color: Color.fromRGBO(30, 62, 98, 0.8),
                                                size: sizeAdapter.adaptbySize(60),
                                              ),
                                          width: sizeAdapter.adaptbyWid(95),
                                          height: sizeAdapter.adaptbyWid(95),
                                        )
                                    ),
                                  ]
                                ),
                                new Text(ListenBookList.booknames_ch[index],
                                  style: new TextStyle(
                                      fontSize: sizeAdapter.adaptbySize(15.0),
                                      color: Color.fromRGBO(30, 62, 98, 1)),
                                  overflow: TextOverflow.ellipsis,
                                )
                            ]
                        )
                      );
                    }
                )
              )
            ]
          ),
        )
    );
  }

}