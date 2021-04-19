import 'package:app1/main.dart';
import 'package:app1/models/user.dart';
import 'package:app1/screens/dash.dart';
import 'package:app1/screens/mesg.dart';
import 'package:app1/screens/signup.dart';
import 'package:app1/services/vprint.dart';
import 'package:app1/widgets/elements.dart';
import 'package:app1/widgets/inputGadgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:app1/globals.dart' as globals;

// ignore: camel_case_types
class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  bool showForm;
  AppTextInput username;
  PasswordField passwordField;

// If authentication was successful
  void authSuccess() async {
    if (globals.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => dashboard(),
        ),
      );
      PravUSER appUser = new PravUSER.fromAppUser(globals.bouncer.appUser);
      globals.dstore.searchObj(appUser.uid).then(
        (result) {
          vprint(
              "Result ObjectFetch", "ObjectSize :" + result.length.toString());
          if (result.length <= 0) {
            globals.dstore.addUser(appUser);
          }
        },
      ).catchError(
        (er) {
          vprint("Error at authSuccess", er.toString(), rtype: "Error");
        },
      );
      //globals.dstore.addUser(globals.appUser);
    }
  }

  @override
  void initState() {
    super.initState();
    showForm = false;
    username = AppTextInput("Email-ID");
    passwordField = PasswordField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(showForm ? "Login" : "Hello\nPrav"),
                spacerWidget(20),
                !showForm
                    ? Column(
                        children: [
                          SignInButton(
                            Buttons.Email,
                            onPressed: () => setState(
                              () {
                                showForm = true;
                              },
                            ),
                          ),
                          SignInButton(
                            Buttons.FacebookNew,
                            onPressed: () {
                              vprint("Facebook AuthAttempt",
                                  "Trying Facebook Authentication..");
                              globals.bouncer.facebookSignIn().then(
                                (_) {
                                  vprint(
                                    "Facebook Sign In Complete",
                                    "Authentication Successful",
                                  );
                                  authSuccess();
                                },
                              );
                            },
                          ),
                          SignInButton(
                            Buttons.Google,
                            onPressed: () {
                              vprint("Google AuthAttempt",
                                  "Trying Google Sign In..");
                              globals.bouncer.googleSignIn().then(
                                (_) {
                                  vprint(
                                    "Google Sign In Complete",
                                    "Authentication Successful",
                                  );
                                  authSuccess();
                                },
                              );
                            },
                          ),
                        ],
                      )
                    : Container(
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            username,
                            spacerWidget(2),
                            passwordField,
                            spacerWidget(12),
                            AppButton(
                              Container(
                                width: 120,
                                height: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(width: 1),
                                ),
                                child: Center(
                                  child: label("Login"),
                                ),
                              ),
                              () {
                                String email = username.formValue;
                                String pswd = passwordField.pswdValue;
                                vprint(
                                  "Email Login Attempt",
                                  "BaseAuth Level 1 : " + email,
                                );
                                globals.bouncer
                                    .emailSignIn(email, pswd)
                                    .then((_) {
                                  vprint(
                                    "Email Sign In Complete",
                                    "Authentication Successful",
                                  );
                                  authSuccess();
                                }).catchError(
                                  (e) {
                                    vprint(
                                      "AuthError",
                                      e.toString(),
                                      rtype: "AuthError",
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => mesgPage(
                                            "AuthError",
                                            "Somethings wrong with Authentication.\nCheck the id and password"),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            spacerWidget(20),
                            // Signup stuff
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppButton(
                                  label("New User?"),
                                  () {
                                    vprint("New User Invoked",
                                        "Moving to register page");
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => registerPage(),
                                      ),
                                    );
                                  },
                                ),
                                AppButton(
                                  label("Use Social Media"),
                                  () => setState(
                                    () {
                                      showForm = false;
                                    },
                                  ),
                                ),
                              ],
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
