import 'package:flutter/material.dart';
import 'PlayPage.dart';
import 'TestPage.dart';
import 'resource.dart';
import 'valueshare.dart';
import 'LyricLoad.dart';
import 'timemarker.dart';
import 'sizeAdapter.dart';
import 'package:audioplayers/audioplayers.dart';

class LisOrTestPage extends StatefulWidget{
  Key key =  Key("_audioplay_");
  static List<String> lyriclines;
  static List<String> allines;
  static List<timemarker> timepoints;
  ListenResource resource;

  LisOrTestPage(ListenResource res){
    resource = res;
    init();
  }

  void init() async{
    await load(false);
  }

  void load(bool isDownFileAnyWay) async{
    // 下载歌词
    LyricLoad load = new LyricLoad(resource);
    print("start load");
    allines = await load.down(isDownFileAnyWay);

    // 初始化纯歌词列表、时间标记
    lyriclines = new List<String>();
    timepoints = new List<timemarker>();

      if(allines == null){
        lyriclines.add("文字加载失败...");
      }else{
        print("load success");
        RegExp timereg = new RegExp(r"\[[0-9]+:[0-9]+\]");
        String time;
        for(int i=0; i<allines.length; i++)
        {
          time = timereg.stringMatch(allines[i]);
          if(time!=null)
          {
            timepoints.add(new timemarker(time.toString(), lyriclines.length));
          }else{
            lyriclines.add(allines[i]);
          }
        }
      }
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _lisOrTestPage();
  }
}

class _lisOrTestPage extends State<LisOrTestPage> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void deactivate(){
    super.deactivate();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
      },
      child: new DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(239, 245, 252, 1),//背景颜色
          appBar: new PreferredSize(
              preferredSize: Size.fromHeight(sizeAdapter.adaptbyHeight(80)),
              child: new AppBar(// appbar
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color:  Color.fromRGBO(30, 62, 98, 1)),
                  elevation: 3.0,
                  centerTitle: true,
                  title: Text(widget.resource.title,
                    style: new TextStyle(fontSize: sizeAdapter.adaptbySize(18),
                      color: Color.fromRGBO(30, 62, 98, 1), ),
                  ),
                  leading: new IconButton(
                      icon: new Icon(Icons.keyboard_arrow_down),
                      onPressed: (){
                        Navigator.of(context).pop();
                  }),
                  bottom: new TabBar(
                        tabs: [
                          new Tab(icon: Icon(Icons.headset)),
                          new Tab(icon: Icon(Icons.create))
                        ],
                        isScrollable: false,
                        labelColor: Color.fromRGBO(246, 190, 77, 1),
                        unselectedLabelColor: Color.fromRGBO(125, 163, 206, 1),
                        indicatorColor: Color.fromRGBO(246, 190, 77, 1),
                        indicatorSize: TabBarIndicatorSize.label,
                      )
              )// appbar
          ),// appbar-preferedsize
          body: TabBarView(
              children: [
                new ListenPlayerPage(widget.resource), new TestPage(widget.resource),
              ],
          ),
      ),
    ));
  }
}