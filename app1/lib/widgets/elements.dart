// UI Elements
// import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

// Text Stuff
Widget header(String line, {Color fntClr: Colors.white}) {
  return Text(
    line,
    style: TextStyle(fontFamily: "AbrilFatface", fontSize: 60),
  );
}

Widget subheader(String line, {Color fntClr: Colors.white}) {
  return Text(
    line,
    style: TextStyle(
      fontFamily: "AbrilFatface",
      fontSize: 40,
    ),
  );
}

Widget label(String line, {Color fntClr: Colors.white}) {
  return Text(
    line,
    style: TextStyle(fontSize: 18.5),
  );
}

Widget smallLabel(String line, {Color fntClr: Colors.white}) {
  return Text(
    line,
    style: TextStyle(
      fontSize: 25,
      color: fntClr,
    ),
  );
}

// For Spacing
Widget spacerWidget(double space) {
  return Padding(
    padding: EdgeInsets.all(space),
  );
}

// Classic Button
class AppButton extends StatefulWidget {
  final Widget buttonItem;
  final Function action;
  AppButton(this.buttonItem, this.action);
  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => widget.action(),
      child: widget.buttonItem,
    );
  }
}

// ignore: must_be_immutable
class AppTileButton extends StatefulWidget {
  final String label;
  final String subtext;
  Function action;
  Widget corner;
  AppTileButton(this.label, this.subtext, this.corner, this.action, {Key key})
      : super(key: key);
  @override
  _AppTileButtonState createState() => _AppTileButtonState();
}

class _AppTileButtonState extends State<AppTileButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => widget.action(),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(7.0),
            child: widget.corner,
          ),
          Container(
            width: 175,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                ),
                Text(
                  widget.subtext,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
