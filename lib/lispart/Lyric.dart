import 'listenTapbar.dart';
import 'PlayPage.dart';
import 'LyricLoad.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'valueshare.dart';
import 'sizeAdapter.dart';
import 'timemarker.dart';
import 'resource.dart';

class LyricPart extends StatefulWidget{
  ListenResource resource;
  ValueNotifierData position;

  LyricPart(ValueNotifierData posi, ListenResource src){
    position = posi;
    resource = src;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LyricPart();
  }
}

class _LyricPart extends State<LyricPart>{
  int startindex;
  int endindex;
  bool isLyric = false;
  bool islistprepared = false;
  bool isheightinit = false;
  List<double> height;
  double lyricheight;
  List<GlobalObjectKey> keys;

  var lyricController = new ScrollController();


  void load(bool isDownFileAnyWay) async{
    // 下载歌词
    LyricLoad load = new LyricLoad(widget.resource);
    print("start load");
    LisOrTestPage.allines = await load.down(isDownFileAnyWay);

    // 初始化纯歌词列表、时间标记
    LisOrTestPage.lyriclines = new List<String>();
    LisOrTestPage.timepoints = new List<timemarker>();

    if(LisOrTestPage.allines == null){
      LisOrTestPage.lyriclines.add("文字加载失败...");
    }else{
      print("load success");
      RegExp timereg = new RegExp(r"\[[0-9]+:[0-9]+\]");
      String time;
      for(int i=0; i<LisOrTestPage.allines.length; i++)
      {
        time = timereg.stringMatch(LisOrTestPage.allines[i]);
        if(time!=null)
        {
          LisOrTestPage.timepoints.add(new timemarker(time.toString(), LisOrTestPage.lyriclines.length));
        }else{
          LisOrTestPage.lyriclines.add(LisOrTestPage.allines[i]);
        }
      }
    }
  }

  void handleValueChanged(){// 歌词显示控制 根据播放进度实现 1. 歌词滚动  2. 歌词高亮
    if(isLyric&&islistprepared) {// 只有在歌词列表在加载中的时候，才可以触发（否则会报错）

      if (isheightinit == false) {// 首次触发需要先更新一下height列表
        for (int i = 0; i < LisOrTestPage.lyriclines.length; i++) {
          height[i] = keys[i].currentContext.size.height;
        }
        print("initial");
        isheightinit = true;
      }

      for (int i = 0; i < LisOrTestPage.timepoints.length; i++) {// 每次触发判断是否需要滚动
          if (LisOrTestPage.timepoints[i].time==widget.position.value) { // 滚动+高亮
            if(mounted){
            setState(() {
              startindex = LisOrTestPage.timepoints[i].posindex;
              if(i<LisOrTestPage.timepoints.length-1)
                endindex = LisOrTestPage.timepoints[i+1].posindex-1;
              else
                endindex = LisOrTestPage.lyriclines.length-1;

              lyricheight = 0;
              for(int j=0; j<startindex; j++){
                lyricheight+=height[j];
              }
            });}

            lyricController.animateTo(lyricheight,
                duration: new Duration(milliseconds: 800),
                curve: Curves.easeInOut);

          }else if(widget.position.value.inSeconds > LisOrTestPage.timepoints[i].time.inSeconds
              && (i<LisOrTestPage.timepoints.length-1)&&(widget.position.value.inSeconds<LisOrTestPage.timepoints[i+1].time.inSeconds)){// 不需要更改高亮，平滑缓缓滚动
            int step = ((widget.position.value.inSeconds - LisOrTestPage.timepoints[i].time.inSeconds)/5).round();
            int totalsteps;
            totalsteps = ((LisOrTestPage.timepoints[i+1].time.inSeconds-LisOrTestPage.timepoints[i].time.inSeconds)/5).round();
            double heightdiff=0;
            for(int j=LisOrTestPage.timepoints[i].posindex; j<=LisOrTestPage.timepoints[i+1].posindex; j++){
              heightdiff+=height[j];
            }
            if(mounted){
            setState(() {
              startindex = LisOrTestPage.timepoints[i].posindex;
              endindex = LisOrTestPage.timepoints[i+1].posindex-1;
              lyricheight = 0;
              for(int j=0; j<LisOrTestPage.timepoints[i].posindex; j++){
                  lyricheight+=height[j];
              }
            });}
            lyricController.animateTo(lyricheight+heightdiff/totalsteps*step, duration: new Duration(milliseconds: 1400), curve: Curves.linear);
          }
      }
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    widget.position.addListener(handleValueChanged);
    startindex = 0;
    endindex = 0;
//    load(false);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    widget.position.removeListener(handleValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: (){
          keys = new List(LisOrTestPage.lyriclines.length);
          height = new List(LisOrTestPage.lyriclines.length);
          setState(() {
            isLyric = !isLyric;
            islistprepared = false;// list在每次setstate重建时会重新加载，所以歌词列表滚动不能需要这个标记
            isheightinit = false;// 每次加载需要初始化item高度
          });
        },
        child:
        isLyric?_lyric(context):_picture(context),
    );
  }

  Widget _picture(BuildContext context){
    return new Container(
//      color:Colors.amberAccent,
//      alignment: Alignment.center,
      child:
      new Padding(
        padding: EdgeInsets.only(
          top: sizeAdapter.adaptbySize(0.0),
          bottom: sizeAdapter.adaptbySize(0.0),
          left: sizeAdapter.adaptbySize(30.0),
          right: sizeAdapter.adaptbySize(30.0)),
        child:
          new Container(
            child: Image.asset('images/drawable-xxhdpi/listenplaypicture1-1.png'),
          )
      ),
    );
  }

  Widget _lyric(BuildContext context){
    return new Container(
//      color: Colors.white,
      child:new Padding(
        padding: EdgeInsets.only(
          top: sizeAdapter.adaptbyHeight(0.0),
          bottom: sizeAdapter.adaptbyHeight(0.0),
          left: sizeAdapter.adaptbyWid(0.0),
          right: sizeAdapter.adaptbyWid(0.0)),
        child:new Stack(
          children: <Widget>[
            new Container(
//              color:Colors.amber,
              alignment: Alignment.center,
              child:new Padding(
                padding: EdgeInsets.only(
                    top: sizeAdapter.adaptbyHeight(0.0),
                    bottom: sizeAdapter.adaptbyHeight(0.0),
                    left: sizeAdapter.adaptbyWid(30.0),
                    right: sizeAdapter.adaptbyWid(30.0)),
                child:Image.asset('images/drawable-xxhdpi/listenplaypicture1-1.png')
            )),
          new  BackdropFilter(
                filter:ImageFilter.blur(sigmaX: 15.0,sigmaY: 15.0),
                child:new Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(239, 245, 252, 1).withOpacity(0.3),
                  ),
                )
          ),
          new Container(
            alignment: Alignment.center,
            child: new Padding(
              padding: EdgeInsets.only(
                top: sizeAdapter.adaptbyHeight(30.0),
                bottom: sizeAdapter.adaptbyHeight(30.0),
                left: sizeAdapter.adaptbyWid(30.0),
                right: sizeAdapter.adaptbyWid(30.0)),
              child:new RefreshIndicator(
                  child: ListView.builder(// 一行歌词构建一个list item（text组件）
                      padding: EdgeInsets.only(
                        top: sizeAdapter.adaptbyHeight(100.0),
                        bottom: sizeAdapter.adaptbyHeight(150.0),
                      ),// 整个list的padding
                      controller: lyricController,
                      cacheExtent: sizeAdapter.adaptbyHeight(200)*LisOrTestPage.lyriclines.length,// 预渲染，否则不在屏幕中的歌词将会被销毁，无法获取key和高度
                      itemCount: LisOrTestPage.lyriclines.length,
                      itemBuilder: (context, index){
                        keys[index] = new GlobalObjectKey(widget.resource.fileurl+"lines:"+index.toString());
                        // 为item创建单独的global key（fileurl+行数）
                        if(index==LisOrTestPage.lyriclines.length-1)islistprepared = true;
                        return new GestureDetector(
                            child:new Container(
//                          color: Colors.amber,
                                child:new Text(
                                  LisOrTestPage.lyriclines[index],
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                  style: new TextStyle(
                                    color:(index >= startindex && index <= endindex)
                                        ? Color.fromRGBO(30, 62, 98, 1) : Color.fromRGBO(125, 163, 206, 1) ,
                                    fontSize: sizeAdapter.adaptbySize(15),
                                    height: sizeAdapter.adaptbyHeight(2.0),
                                  ),
                                  key: keys[index],
                                )
                            )// text container
                        );// gesture detector
                      }
                  ),
                  onRefresh: _refreshLyric)
              ),// padding childof container
          ),// container of lyric
        ],
      ),
    ));
  }

  Future<void> _refreshLyric() async{
    await load(true);
    if(mounted){
    setState(() {
      islistprepared = false;// list在每次setstate重建时会重新加载，所以歌词列表滚动不能需要这个标记
      isheightinit = false;// 每次加载需要初始化item高度
    });
  }}
}