import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Profile.dart';
import 'lispart/sizeAdapter.dart';

class homeBottomNavigation extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _homeBottomNavigation();
  }
}

class _homeBottomNavigation extends State<homeBottomNavigation>{
  static int _currentindex ;
  static List<StatefulWidget> _currentpages ;
  var _pagecontroller = new PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentindex = 0 ;
    _currentpages = [new HomePage(),new Profile()];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new PageView(
        children: _currentpages,
        controller: _pagecontroller,
        onPageChanged: (int i){
          setState(() {
            _currentindex = i;
          });
        },
      ),
      bottomNavigationBar: PreferredSize(
          child: new BottomNavigationBar(
                selectedFontSize: sizeAdapter.adaptbySize(9),
                unselectedFontSize: sizeAdapter.adaptbySize(8),
                selectedIconTheme: new IconThemeData(size: sizeAdapter.adaptbySize(25)),
                unselectedIconTheme: new IconThemeData(size: sizeAdapter.adaptbySize(20)),
                selectedItemColor: Color.fromRGBO(246, 190, 77, 1),
                currentIndex: _currentindex,
                items: [
                  new BottomNavigationBarItem(
                      icon: new Icon(Icons.home),
                      title: Text("首页")
                  ),
                  new BottomNavigationBarItem(
                      icon: new Icon(Icons.face),
                      title: Text("我的")
                  )
                ] ,
                onTap: (int i){
                  setState(() {
                    _currentindex = i;
                    _pagecontroller.animateToPage(
                        _currentindex,
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                },
              ),
          preferredSize:Size.fromHeight(sizeAdapter.adaptbyHeight(15)))
    );
  }
}