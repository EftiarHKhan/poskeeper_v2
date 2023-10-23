import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();


  final _db = FirebaseFirestore.instance;
  final String key = 'myUIDKey';

  creatUser(UserModel2 user,String uid) async {
    await _db.collection("Users").doc(uid).set(user.toJson2())
        .whenComplete(() => Get.snackbar('Success', 'Your account has been created'))
        .catchError((error,stackTrace){
          Get.snackbar('Error', 'Something went wrong. Try again');
    });
  }

  Future<UserModel2> getUserDetails(String email) async{
    final snapshot = await _db.collection("Users").where("Email" , isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel2.fromSnapshot(e)).single;
    return userData;
  }

  Future<void> updateUserRecord(UserModel2 user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(key) ?? '';

    if (uid.isNotEmpty) {
      await _db.collection("Users").doc(uid).update(user.toJson2());
      Get.snackbar('Update', 'Profile updated successfully');
    } else {
      Get.snackbar('Error', 'User ID is empty or not available');
    }
  }

}