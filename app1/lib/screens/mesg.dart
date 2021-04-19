import 'package:app1/widgets/elements.dart';
import 'package:flutter/material.dart';

class mesgPage extends StatefulWidget {
  final String title, mesg;
  mesgPage(this.title, this.mesg);
  @override
  _mesgState createState() => _mesgState();
}

class _mesgState extends State<mesgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          width: 400,
          height: 400,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                subheader(widget.title),
                spacerWidget(12),
                label(widget.mesg),
                spacerWidget(20),
                AppButton(label("Ok"), () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
