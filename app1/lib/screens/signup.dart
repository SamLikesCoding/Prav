import 'package:app1/globals.dart' as globals;
import 'package:app1/models/user.dart';
import 'package:app1/screens/dash.dart';
import 'package:app1/screens/login.dart';
import 'package:app1/screens/mesg.dart';
import 'package:app1/services/vprint.dart';
import 'package:app1/widgets/elements.dart';
import 'package:app1/widgets/inputGadgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class registerPage extends StatefulWidget {
  @override
  _registerPageState createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  static AppTextInput usrName, email, mnum;
  static PasswordField pswd;
  static PasswordField cnfPswd;

  // Where all inputs are stored
  Map<String, dynamic> formInputs = {};

  @override
  void initState() {
    super.initState();
    usrName = AppTextInput("Screen Name");
    email = AppTextInput("Email ID");
    mnum = AppTextInput(
      "Mobile Number",
      isNumber: true,
    );
    pswd = PasswordField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacerWidget(70),
                header("New User"),
                spacerWidget(20),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      usrName,
                      email,
                      mnum,
                      spacerWidget(12),
                      pswd,
                      spacerWidget(29),
                      AppButton(
                        Container(
                          //width: 100,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: label("Sign Up"),
                          ),
                        ),
                        () async {
                          //getting data
                          String userName = usrName.formValue;
                          String passwd = pswd.pswdValue;
                          String mailID = email.formValue;
                          String phone = mnum.formValue;

                          // Null check
                          bool nullCase = (userName.isEmpty ||
                              mailID.isEmpty ||
                              phone.isEmpty ||
                              passwd.isEmpty);

                          // Checking the cases...
                          if (nullCase) {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => mesgPage(
                                  "Empty Fields",
                                  "Please fill up the fields",
                                ),
                              ),
                            );
                          } /*else if (!EmailValidator.validate(
                              mailID, true, true)) {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => mesgPage(
                                  "Invalid Email ID",
                                  "Please enter a valid email id",
                                ),
                              ),
                            );
                          } else if (phone.length == 10) {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => mesgPage(
                                  "Invalid Email ID",
                                  "Please enter a valid email id",
                                ),
                              ),
                            );
                          } */
                          else {
                            // Authentication happends here
                            try {
                              await globals.bouncer.signUp(mailID, passwd).then(
                                (_) {
                                  globals.bouncer.appUser
                                      .updateProfile(displayName: userName)
                                      .catchError(
                                    (mesg) {
                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                          builder: (context) => mesgPage(
                                              "AuthError",
                                              "Somethings wrong on signing up\nDouble check on what typed"),
                                        ),
                                      );
                                    },
                                  );
                                  PravUSER appUser = PravUSER.fromAppUser(
                                    globals.bouncer.appUser,
                                  );
                                  appUser.mobileNumber = phone;
                                  appUser.dispName = userName;
                                  globals.dstore.searchObj(appUser.uid).then(
                                    (dQuery) {
                                      if (dQuery.length <= 0) {
                                        globals.dstore.addUser(appUser).then(
                                          (value) {
                                            usrName.reset();
                                            email.reset();
                                            mnum.reset();
                                            pswd.reset();
                                            Navigator.of(context)
                                                .pushReplacement(
                                              new MaterialPageRoute(
                                                builder: (context) =>
                                                    dashboard(),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            } catch (e) {
                              Navigator.of(context).push(
                                new MaterialPageRoute(
                                  builder: (context) => mesgPage("AuthError",
                                      "Somethings wrong on signing up\nDouble check on what typed"),
                                ),
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
                spacerWidget(28),
                AppButton(
                  label("Go Back"),
                  () => Navigator.of(context).pop(),
                ),
                spacerWidget(20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
