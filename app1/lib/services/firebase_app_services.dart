import 'package:app1/screens/mesg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app1/globals.dart' as globals;
import 'package:app1/services/vprint.dart';
import 'package:app1/models/user.dart';

//
//
//        Authentication Module
//
//
abstract class BaseAuth {
  Future<void> emailSignIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> googleSignIn();
  Future<void> facebookSignIn();
  //Future<void> emailVerify();
  Future<void> logout();
}

class AppAuthentication implements BaseAuth {
  static FirebaseAuth agent;
  static User appUsr;
  UserCredential ucr;
  final BuildContext ctx;

  AppAuthentication(this.ctx) {
    vprint("AuthObject Initalization",
        "Authentication Object has been initalized");
    setup();
  }

  setup() async {
    await Firebase.initializeApp().then(
      (app) {
        agent = FirebaseAuth.instanceFor(app: app);
        agent.authStateChanges().listen(
          (appUser) {
            if (appUser != null) {
              globals.isLoggedIn = true;
              appUsr = appUser;
            } else {
              globals.isLoggedIn = false;
            }
          },
        );
      },
    );
  }

  //User get appUserObject => appUsr;

  Future<void> emailSignIn(String email, String password) async {
    try {
      await agent
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        vprint("Email Login", "Email Authentication was successful");
        ucr = value;
      }).catchError(
        (e) {
          Navigator.of(ctx).push(
            new MaterialPageRoute(
              builder: (context) => mesgPage(
                  "AuthWrong", "Make sure your password and email id is valid"),
            ),
          );
        },
      );
    } catch (e) {
      vprint(
        "ErrorInvoke",
        e.toString(),
        rtype: "AuthError",
      );
    }
  }

  Future<void> googleSignIn() async {
    GoogleAuthCredential gcred;
    try {
      await GoogleSignIn().signIn().then(
        (user) async {
          vprint("Basic Sign In", "Entered AuthBase Level");
          await user.authentication.then(
            (gAuthObject) async {
              vprint("gAuthenticationLevel", "Entered gAuth Level");
              gcred = GoogleAuthProvider.credential(
                accessToken: gAuthObject.accessToken,
                idToken: gAuthObject.idToken,
              );
              await agent.signInWithCredential(gcred).then(
                (ucred) {
                  vprint("AuthSuccess",
                      "The Authentication to Google is successful");
                  ucr = ucred;
                },
              );
            },
          );
        },
      );
    } catch (e) {
      vprint("ErrorInvoke", "GoogleSignInError" + e.toString(),
          rtype: "AuthError");
    }
  }

  Future<void> facebookSignIn() async {
    try {
      vprint("Facebook AuthCheckpoint", "Checking entry to login level...");
      await FacebookAuth.instance.login().then(
        (res) async {
          vprint("Facebook AuthCheckpoint",
              "Checking entry to credential level...");
          final FacebookAuthCredential fbCred =
              FacebookAuthProvider.credential(res.accessToken.token);
          await agent.signInWithCredential(fbCred).then(
            (ucred) {
              ucr = ucred;
            },
          );
        },
      );
    } catch (e) {
      vprint("ErrorInvoke", "FacebookSignInError" + e.toString(),
          rtype: "AuthError");
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      print("Trying to signup...");
      await agent
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          //print("done.");
          ucr = value;
        },
      ).catchError(
        (e) {
          print(e.toString());
          Navigator.of(ctx).push(
            new MaterialPageRoute(
              builder: (context) => mesgPage(
                  "AuthWrong", "Make sure your password and email id is valid"),
            ),
          );
        },
      );
    } catch (e) {
      vprint("SignUpError", e.toString(), rtype: "AuthError");
    }
  }

  Future<void> logout() async {
    ucr = null;
    return agent.signOut();
  }

  // Gettters, just in case
  User get appUser => appUsr;
  UserCredential get appUCred => ucr;
}

//
//
//    Firestore Section
//
//
class FbaseFstore {
  FirebaseFirestore storeApp;
  CollectionReference appUserList;

  FbaseFstore() {
    setup().whenComplete(() {
      vprint("FBase INIT", "Firestore is ready");
    });
  }

  Future setup() async {
    await Firebase.initializeApp().then((app) async {
      storeApp = FirebaseFirestore.instanceFor(app: app);
      appUserList = storeApp.collection("users");
    }).catchError(
      (e) {
        vprint("Fbase DatastoreError", "Something's wrong" + e.toString());
      },
    );
  }

  Future addUser(PravUSER user) {
    return appUserList.add(user.toMap()).then((value) {
      vprint("AddUser Note", "Added New User");
    }).catchError((e) => vprint("AddUSer error", "Error:" + e.toString()));
  }

  // Simple find function
  Future searchObj(String key) async {
    var res = [];
    try {
      await appUserList.where("uid", isEqualTo: key).get().then((value) {
        if (value != null) {
          res = value.docs;
        }
      }).catchError((er) {
        vprint("APIError", er.toString());
      });
    } catch (e) {
      vprint("CallError", e.toString());
    }
    return res;
  }

  //find users
  finddUser(String usrname) async {
    await appUserList.where("name", isEqualTo: usrname).get().then((value) {
      value.docs.forEach((element) {
        print("Fetch : " + element.data().toString());
      });
    });
  }

  // Fetch Personal Messages
  //  --- Need workaround here --
  Future<Stream> getMsgStream() async {
    return appUserList
        .where("uid", isEqualTo: globals.bouncer.appUser.uid)
        .snapshots();
  }

  // Just in Case
  Future<void> closeSess() async {
    storeApp.terminate();
  }
}
