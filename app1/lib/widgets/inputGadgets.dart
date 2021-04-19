import 'package:app1/services/vprint.dart';
import 'package:flutter/material.dart';

enum fieldType { PASSWORD, EMAIL_ID, PHONE_NO, NORM_TXT }

// ignore: must_be_immutable
class AppTextInput extends StatefulWidget {
  TextEditingController _controller;
  final String label;
  bool isNumber = false;

  AppTextInput(this.label, {this.isNumber: false, Key key}) : super(key: key);
  String get formValue => _controller.text;
  bool isEmpty() => _controller.text.isEmpty;
  reset() => _controller.clear();

  @override
  _AppTextInputState createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  @override
  void initState() {
    super.initState();
    widget._controller = new TextEditingController();
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        keyboardType:
            widget.isNumber ? TextInputType.number : TextInputType.text,
        controller: widget._controller,
        decoration: InputDecoration(
          //errorText: validateField(_controller.text, type: widget.ftype),
          labelText: widget.label,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PasswordField extends StatefulWidget {
  TextEditingController _controller;
  final String label;

  PasswordField({this.label: "Password", Key key}) : super(key: key);
  String get pswdValue => _controller.text;
  bool isEmpty() => _controller.text.isEmpty;
  reset() => _controller.clear();

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  void initState() {
    super.initState();
    widget._controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: widget._controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: widget.label,
        ),
      ),
    );
  }
}
