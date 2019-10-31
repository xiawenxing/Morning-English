import 'package:flutter/material.dart';
import 'lispart/sizeAdapter.dart';
import 'dart:ui';

class Profile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _profile();
  }
}
class _profile extends State<Profile>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop:(){
        Navigator.of(context).pop();
      },
      child:Scaffold(
          backgroundColor: Color.fromRGBO(239, 245, 252, 1),//背景颜色
          body: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget>[
                new Card(
                    child:new Stack(
                      children: <Widget>[
                        new SizedBox(
                          height:sizeAdapter.adaptbyHeight(300),
                          width: sizeAdapter.adaptfitWid(),
                          child: Image.asset("images/drawable-xxhdpi/223.png",
                            fit: BoxFit.fill,),
                        ),
                        new BackdropFilter(
                            filter:ImageFilter.blur(sigmaX: 2.0,sigmaY: 2.0),
                            child:new Container(
                              height:sizeAdapter.adaptbyHeight(300),
                              width: sizeAdapter.adaptfitWid(),
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color.fromRGBO(239, 245, 252, 1).withOpacity(0.3),
                              ),
                            )),
                        new SizedBox(
                          height:sizeAdapter.adaptbyHeight(300),
                          width: sizeAdapter.adaptfitWid(),
                          child: new Container(
                            child: new Padding(
                              padding: EdgeInsets.only(top: sizeAdapter.adaptbyHeight(60),
                                  bottom: sizeAdapter.adaptbyHeight(60)),
                              child: Image.asset("images/drawable-xxhdpi/221.png",
                              fit: BoxFit.contain,)
                            ),
                          ),
                          )
                      ],
                    )),
                new Expanded(
                  child: new ListView(
                    children: <Widget>[
                      new Divider(),
                      new ListTile(
                        leading: Icon(Icons.settings),
                        title: new Text("设置"),
                      ),
                      new Divider(),
                      new ListTile(
                        leading: Icon(Icons.menu),
                        title: new Text("备忘"),
                      ),
                      new Divider()
                    ],
                  ),
                )
              ]
          )
      )
    );
}
}