import 'package:app1/services/firebase_app_services.dart';
import 'package:app1/widgets/elements.dart';
import 'package:app1/screens/splash.dart';
import 'package:app1/screens/login.dart';
import 'package:app1/screens/dash.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'services/vprint.dart';

void main() {
  globals.errorDebug = true;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    new MaterialApp(
      theme: ThemeData(fontFamily: "Barlow"),
      home: new PRAV_App(),
    ),
  );
}

// ignore: camel_case_types
class PRAV_App extends StatefulWidget {
  @override
  _PRAV_AppState createState() => _PRAV_AppState();
}

// ignore: camel_case_types
class _PRAV_AppState extends State<PRAV_App> {
  @override
  void initState() {
    super.initState();
    globals.bouncer = new AppAuthentication(context);
    globals.dstore = new FbaseFstore();
  }

  @override
  Widget build(BuildContext context) {
    vprint("Entry Point", "Running at Entry Point");
    return Splash(
      Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo2.png",
                width: 110,
                height: 110,
              ),
            ],
          ),
        ),
      ),
      4,
      () => Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => globals.isLoggedIn ? dashboard() : login(),
        ),
      ),
    );
  }
}
