import 'package:app1/globals.dart' as globals;

void vprint(String title, String rMesg, {String rtype: "RunLog"}){
  if (globals.isLoggedIn) {
    print("\n+=( Log )================================================+");
    print(" $title ");
    print(" type : $rtype \n");
    print(rMesg);
    print("\n+========================================================+");
  }
}