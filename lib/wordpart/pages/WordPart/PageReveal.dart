import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;
  PageReveal({
    this.revealPercent,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      clipper:new CricleRevealClipper(revealPercent),
      child:child,
    );
  }
}

class CricleRevealClipper extends CustomClipper<Rect>{
  final double revealPercent;
  CricleRevealClipper(this.revealPercent);
  @override
  Rect getClip(Size size){
    final epiccenter=new Offset(size.width/2,size.height*0.9);
    //Calculate distance from epiccenter to the top left
    double theta=atan(epiccenter.dy/epiccenter.dx);
    final distanceToCorner=epiccenter.dy/sin(theta);
    final radius=distanceToCorner*revealPercent;
    final diameter=2*radius;
    return new Rect.fromLTWH(epiccenter.dx-radius,epiccenter.dy-radius,diameter,diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
