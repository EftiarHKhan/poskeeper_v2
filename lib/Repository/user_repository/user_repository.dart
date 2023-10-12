import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();


  final _db = FirebaseFirestore.instance;

  creatUser(UserModel user,String uid) async {
    await _db.collection("Users").doc(uid).set(user.toJson())
        .whenComplete(() => Get.snackbar('Success', 'Your account has been created'))
        .catchError((error,stackTrace){
          Get.snackbar('Error', 'Something went wrong. Try again');
    });
  }

}