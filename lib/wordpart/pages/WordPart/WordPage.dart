import 'dart:async';
import 'package:csxy/wordpart/model/Word.dart';
import 'package:flutter/material.dart';
import 'BookUnitView.dart';
import 'BookView.dart';
import 'PageDragger.dart';
import 'PageReveal.dart';
import 'package:csxy/wordpart/Globals.dart' as Globals;

class WordPageViewModel{

  final int Bookid;
  final int Listid;
  final int Unitid;
  final int id;
  final String Spanish;
  final String Chinese;

  WordPageViewModel(
      this.Bookid,
      this.Listid,
      this.Unitid,
      this.id,
      this.Spanish,
      this.Chinese
      );
}

//this is for the detailed word part
class DetailView extends StatefulWidget{
  int Listid;
  int Unitid;
  int Bookid;
  int entryNum;
  List<WordPageViewModel> viewModel;
  DetailView(this.Listid,this.Unitid,this.Bookid,this.entryNum);
  @override
  State<StatefulWidget> createState() =>new _DetailViewState();
}

class _DetailViewState extends State<DetailView> with TickerProviderStateMixin{

  List<WordPageViewModel> FinalviewModel=null; //page set
  double percentVisible=1.0;
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;
  int activeIndex=0;
  int nextPageIndex=0;
  SlideDirection slideDirection=SlideDirection.none;
  double slidePercent=0.0;

  loadAsyncData() async{
    //get data
    List<Word> list=await Globals.DB.WordDB.queryWord("Book"+(widget.Bookid+1).toString(),widget.Listid,widget.Unitid); //this is listid
    List<WordPageViewModel> viewModels=new List<WordPageViewModel>();
    for(Word word in list){
      viewModels.add(new WordPageViewModel(widget.Bookid,widget.Listid,widget.Unitid,word.Id,word.Spanish,word.Type+" "+word.Chinese));
      print("Spanish:"+word.Spanish+",Type:"+word.Type+",Chinese:"+word.Chinese);
    }
    return viewModels;
  }

  @override
  void initState(){
    loadAsyncData().then((res){
      setState(() {
        this.FinalviewModel=res;
      });
    });
  }

  _DetailViewState(){
    this.slideUpdateStream=new StreamController<SlideUpdate>();
    this.slideUpdateStream.stream.listen((SlideUpdate event){
      setState((){
        if(event.UpdateType==UpdateType.dragging){
          slideDirection=event.direction;
          slidePercent=event.slidePercent;

          if(slideDirection==SlideDirection.leftToRight){

            nextPageIndex=activeIndex-1;

          }else if(slideDirection==SlideDirection.rightToLeft){

            nextPageIndex=activeIndex+1;
          }else{

            nextPageIndex=activeIndex;
          }
        }else if(event.UpdateType==UpdateType.doneDragging){
          if(slidePercent>0.5){

            animatedPageDragger=new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync:this,
            );

          }else{
            animatedPageDragger=new AnimatedPageDragger(
            slideDirection: slideDirection,
            transitionGoal: TransitionGoal.close,
            slidePercent: slidePercent,
            slideUpdateStream: slideUpdateStream,
            vsync:this,
          );
            nextPageIndex=activeIndex;
          }
          animatedPageDragger.run();
        }else if(event.UpdateType==UpdateType.animating){
          slideDirection=event.direction;
          slidePercent=event.slidePercent;
        }
        else if(event.UpdateType==UpdateType.doneAnimating){
          activeIndex=nextPageIndex;
          slideDirection=SlideDirection.none;
          slidePercent=0.0;

          animatedPageDragger.dispose();
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //get the resources here
    if(FinalviewModel==null){
      // This is what we show while we're loading
      return new MaterialApp(
        home:new Scaffold(
          body:new Container(
            decoration:new BoxDecoration(
              color: Colors.grey,
            ),
            child: Text("下载中..."),
          ),
        ),
        theme:new ThemeData(
            brightness:Brightness.light,
            backgroundColor: Colors.white),
      );
    }else{
      // TODO: implement build
      return new MaterialApp(
        home:new Scaffold(
          appBar: AppBar(
            title: Text("Lista"+widget.Listid.toString()+" Unidad"+widget.Unitid.toString()+" "+(activeIndex+1).toString()),
            elevation:0.5,
            flexibleSpace: Container(color:Colors.grey),
            leading:Builder(
              builder:(BuildContext context){
                return IconButton(icon:new Icon(Icons.home),
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder:
                      //this.Listid,this.Bookid,this.entryNum
                      (context)=>BookUnitView(widget.Listid,widget.Bookid,widget.entryNum))
                  );
                },); //add onPress later
              },
            ),
            actions:<Widget>[
              IconButton(
                icon:Icon(Icons.arrow_forward),
                onPressed:(){
                  int nextListid;
                  int nextUnitid;
                  int currentPass=(widget.Listid-1)*100+(widget.Unitid-1)*10+FinalviewModel.length;
//                  print("FinalviewModel.length:"+FinalviewModel.length.toString());
//                  print("currentPass:"+currentPass.toString());
//                  print("widget.entryNum:"+widget.entryNum.toString());
                  if(widget.entryNum-currentPass>0&&widget.Unitid!=10){
                    nextListid=widget.Listid;
                    nextUnitid=widget.Unitid+1;
                    Navigator.push(context,MaterialPageRoute(builder:
                    //this.Listid,this.Unitid,this.Bookid,this.entryNum
                        (context)=>DetailView(nextListid,nextUnitid,widget.Bookid,widget.entryNum))
                    );
                  }else if(widget.entryNum-currentPass>0&&widget.Unitid==10){
                    nextListid=widget.Listid+1;
                    nextUnitid=1;
                    Navigator.push(context,MaterialPageRoute(builder:
                        (context)=> BookUnitView(nextListid,widget.Bookid,widget.entryNum))
                    );
                  }else if(widget.entryNum==currentPass){
                    Navigator.push(context,MaterialPageRoute(builder:
                    //this.Listid,this.Unitid,this.Bookid,this.entryNum
                        (context)=>BookView())
                    );
                  }
                }
              ),
            ]
            ,
          ),
          body:new Stack(
            children: [
              new PageItem(viewModel:FinalviewModel[activeIndex],percentVisible:percentVisible,),
              new PageReveal(
                revealPercent:slidePercent,
                child:
                new PageItem(viewModel:FinalviewModel[nextPageIndex],percentVisible:slidePercent,),
              ),
              new PageDragger(
                canDragLeftToRight: activeIndex>0,
                canDragRightToLeft: activeIndex<FinalviewModel.length-1,
                slideUpdateStream: this.slideUpdateStream,
              ),
            ],
          ),
        ),
      );
    }
  }
}


class PageItem extends StatelessWidget {

  final bgcolor=0xFFEFF5FC;
  final spanishcolor=0xFF1E3E62;
  final chinesecolor=0xFF7DA3CE;
  final WordPageViewModel viewModel;
  final double percentVisible;
  PageItem({this.viewModel,
    this.percentVisible=1.0,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width:MediaQuery.of(context).size.width,
      color:Color(bgcolor),
      child:new Opacity(
        opacity: percentVisible,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Transform(
                transform:new Matrix4.translationValues(0.0,50.0*(1.0-percentVisible),0.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 150.0),
                  child: new Text(viewModel.Spanish,
                        style:TextStyle(color: Color(spanishcolor).withOpacity(1.0),
                            fontFamily:'FlamanteRoma',fontSize:40.0, fontWeight: FontWeight.bold)),
                ),
                ),
            new Transform(
              transform: new Matrix4.translationValues(0.0, 30.0*(1-percentVisible), 0),
              child: new Container(
                  decoration: BoxDecoration(
                    image:DecorationImage(
                      image:ExactAssetImage("pictures/singlewordbg.png"),
                      fit:BoxFit.contain,),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: new Text(viewModel.Chinese,textAlign:TextAlign.center,
                          style:TextStyle(color: Color(chinesecolor).withOpacity(1.0),
                              fontFamily:'FlamanteRoma',fontSize:20.0,fontWeight: FontWeight.bold)),
                    ),

                ),

            ),
          ],
        ),
      ),
    );
  }
}
