import 'package:firebase_auth/firebase_auth.dart';

class PravUSER {
  String name;
  String email;
  String phone;
  String uid;
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _members = [];
  List requests = [];

  PravUSER(this.uid, this.name, this.email, this.phone);

  List get messageStock => _messages;

  addToMessageStock(Map<String, dynamic> mesg) {
    _messages.add(mesg);
  }

  set mobileNumber(String phone) {
    this.phone = phone;
  }

  set dispName(String name) {
    this.name = name;
  }

  factory PravUSER.fromMap(Map<String, dynamic> obj) {
    return PravUSER(obj["uid"], obj["name"], obj["email"], obj["phone"]);
  }

  factory PravUSER.fromAppUser(User user) {
    return PravUSER(user.uid, user.displayName, user.email, user.phoneNumber);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phone": phone,
      "messages": _messages,
      "members": _members,
      "requests": requests,
    };
  }
}
