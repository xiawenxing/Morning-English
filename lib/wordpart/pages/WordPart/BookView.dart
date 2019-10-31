import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csxy/wordpart/pages/WordPart/BookListView.dart';
import 'package:csxy/wordpart/Globals.dart' as Globals;
import 'package:csxy/BottomNavi.dart';
//this is for the book view actually

class BookView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>new _BookViewState();

}
class _BookViewState extends State<BookView>{
  final bgcolor=0xFFEFF5FC;
  final cardcolor=0xFF87CEFA;
  //final List booksname=['西班牙语八级大纲词汇（除动词）','DELE3000高频词汇'];
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home:new Scaffold(
        appBar: AppBar(
          title: Text('单词书'),
          elevation:0.5,
          flexibleSpace: Container(color:Colors.grey),
          leading:Builder( 
            builder:(BuildContext context){
              return IconButton(icon:new Icon(Icons.home),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder:
                    (context)=>homeBottomNavigation())
                );
              },); //add onPress later
            },
          ),
        ),
        body:new Container(
          decoration:new BoxDecoration(
            color: Color(bgcolor),
          ),
          child: ListView(
            children:_buildBookList(),
          ),//_buildBookList(),
        ),
      ),
      theme:new ThemeData(
          brightness:Brightness.light,
          backgroundColor: Colors.white),
    );
  }

  // ignore: unused_element
  List<Widget> _buildBookList(){
//    new ListView.builder(
//        itemCount: Globals.Books.bookNum*2,
//        padding: const EdgeInsets.all(16.0),
//        itemBuilder: (context, i) {
//          // add the divider line
//          if (i.isOdd) return new Divider();
//          int index=i~/2;
//          return _buildRow(index,context);
//        }
//    );

    List<Widget> widgetList=new List();
    for(int i=0;i<Globals.Books.bookNum;i++){
      widgetList.add(_buildRow(i,context));
    }
    return widgetList;

  }

  Widget _buildRow(int id,BuildContext context) {
    return Card(
      child: new ListTile(
          leading:Image.asset("images/"+Globals.Books.bookImages[id],width:56.0,height:72.0),
          title: new Text(
              Globals.Books.bookNames[id],
              style:TextStyle(color: Colors.black.withOpacity(1.0),fontSize:18.0)
          ),
          subtitle: Text('词典简介'),
          onTap:(){
            //await ;
            Navigator.push(context,MaterialPageRoute(builder:
                (context)=>BookListView(id))
            );
          },
        ),
      color: Color(bgcolor),
    );
  }
}




//It is not complete.
class SearchAppBarWidget extends StatefulWidget implements PreferredSizeWidget{
  final double height;
  final double elevation;
  final Widget leading;
  final String hintText;
  final FocusNode focusNode;
  final TextEditingController controller;
  final IconData prefixIcon;
  final List<TextInputFormatter> inputFormatters;
  final VoidCallback onEditingComplete;

  const SearchAppBarWidget(
  {Key key,this.height:46.0,
    this.elevation:0.5,
    this.leading,
    this.hintText:'查词',
    this.focusNode,
    this.controller,
    this.prefixIcon:Icons.search,
    this.inputFormatters,
    this.onEditingComplete}
      ):super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SearchAppBarWidgetState();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;

}
class _SearchAppBarWidgetState extends State<SearchAppBarWidget>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}