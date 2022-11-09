import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImageRotate extends StatefulWidget {
  @override
  _ImageRotateState createState() => new _ImageRotateState();
}

class _ImageRotateState extends State<ImageRotate>
    with SingleTickerProviderStateMixin {


  AnimationController? animationController;

  @override
  dispose() {
    animationController!.dispose(); // you need this
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );

    animationController!.repeat();
  }



  @override
  Widget build(BuildContext context) {
    return Center(
            child: Container(

                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: animationController!,
                  child: Container(
                    child: Image.asset('assets/images/loading.png',
                      width: 200, height: 200, fit: BoxFit.contain,),
                  ),
                  builder: (BuildContext? context, Widget? _widget) {
                    return Transform.rotate(
                      angle: animationController!.value * 6.3,
                      child: _widget,
                    );
                  },
                )),
          );




  }
}