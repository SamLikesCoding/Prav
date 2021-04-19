import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app1/globals.dart' as globals;
import 'package:flutter/material.dart';

class ChatWindow extends StatefulWidget {
  FirebaseFirestore _instance;
  User _user;
  bool haveMet;

  ChatWindow() {
    _user = globals.bouncer.appUser;
    _instance = globals.dstore.storeApp;
  }

  checkMeet() async {
    _instance
        .collection("users")
        .where("uid", isEqualTo: _user.uid)
        .get()
        .then((obj) {
      obj.docs.first.data()["members"].containsValue("value");
    });
  }

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(),
        ),
      ),
    );
  }
}
