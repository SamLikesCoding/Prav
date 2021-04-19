// ignore: library_names
library globals;

import 'package:app1/models/user.dart';
import 'services/firebase_app_services.dart';

var gbuffer;
bool isLoggedIn = false;
bool setScreenLoading = false;
bool errorDebug;
AppAuthentication bouncer;
FbaseFstore dstore;
//PravUSER appUser;

RegExp emailRgx =
    new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$");
