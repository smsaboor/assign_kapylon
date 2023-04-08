
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static addUserToFirebase(var data) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc()
        .set(data).then((value) {
      print('user added');
    }).catchError((e) {
      print('$e user not added');
    });
  }
  static getUserFromFirebase() async {
    var users= FirebaseFirestore.instance
        .collection("users").get();
    return users;
  }
}
