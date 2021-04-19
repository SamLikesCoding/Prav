import 'package:app1/screens/login.dart';
import 'package:app1/services/vprint.dart';
import 'package:app1/widgets/elements.dart';
import 'package:app1/widgets/inputGadgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app1/globals.dart' as globals;

// ignore: camel_case_types
class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

// ignore: camel_case_types
class _dashboardState extends State<dashboard> {
  TextEditingController _tchlr;
  List searchRes;

  @override
  void initState() {
    super.initState();
    _tchlr = new TextEditingController();
    searchRes = [];
  }

  @override
  void dispose() {
    _tchlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: PageView(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subheader("Let's talk to..."),
                      spacerWidget(40),
                      Container(
                        width: 400,
                        child: TextFormField(
                          controller: _tchlr,
                        ),
                      ),
                      AppButton(label("Search"), () async {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .where("name", isEqualTo: _tchlr.text)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            print(element.data());
                          });
                        });
                      }),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spacerWidget(20),
                      subheader("Hi"),
                      header(globals.bouncer.appUser.displayName),
                      spacerWidget(20),
                      Container(
                        width: 400,
                        child: Column(
                          children: [
                            AppButton(
                              Text("Sign out"),
                              () {
                                vprint("SignOut Event", "Signing out...");
                                globals.bouncer.logout().whenComplete(
                                  () {
                                    vprint(
                                      "SignOut Completed",
                                      "The User has been Signed out",
                                    );
                                    Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                        builder: (context) => login(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*



 */
