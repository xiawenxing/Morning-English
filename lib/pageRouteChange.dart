import 'package:flutter/material.dart';

class fadePageRouteBuilder extends PageRouteBuilder{
  final Widget _widget;

  fadePageRouteBuilder(this._widget):super(
    transitionDuration : const Duration(milliseconds: 900),
    pageBuilder :
        (BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2){
      return _widget;
    },
    transitionsBuilder:
        (BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2,
        Widget child){
      return FadeTransition(
        opacity: Tween(begin: 0.0 ,end: 1.0).animate(
          CurvedAnimation(parent: animation1,
              curve: Curves.easeInOut)
        ),
        child: child,
      );
    }
  );
}

class scalePageRouteBuilder extends PageRouteBuilder{
  final Widget _widget;

  scalePageRouteBuilder(this._widget):super(
    transitionDuration: new Duration(seconds: 1),
    pageBuilder:
        (BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2){
      return _widget;
    },
    transitionsBuilder:
        (BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2,
        Widget child){
      return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animation1,
                curve: Curves.fastOutSlowIn)
          ),
          child: child,
      );
        }
  );
}

class rotationScalePageRouteBuilder extends PageRouteBuilder {
  // 跳转的页面
  final Widget widget;

  rotationScalePageRouteBuilder(this.widget) :super(
      transitionDuration: Duration(seconds: 1),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0)
              .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: ScaleTransition(scale: Tween(begin: 0.0, end: 1.0)
              .animate(
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),),
            child: child,),
        );
      }
  );
}


class slidePageRouteBuilder extends PageRouteBuilder {
  // 跳转的页面
  final Widget widget;

  slidePageRouteBuilder(this.widget) :super(
      transitionDuration: Duration(milliseconds: 600),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
              begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
              .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: child,);
      }
  );
}
