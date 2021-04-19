import 'package:flutter/material.dart';
import 'dart:async';

// ignore: must_be_immutable
class Splash extends StatefulWidget {
  Function next;
  Widget placer;
  int duration;
  Splash(this.placer, this.duration, this.next, {Key key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: widget.duration), () => widget.next());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.placer,
    );
  }
}