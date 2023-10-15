import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';
import 'package:stormen/Repository/authentication_repository/authentication_repository.dart';
import 'package:stormen/Repository/user_repository/user_repository.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();


  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final storename = TextEditingController();
  final String key = 'myUIDKey';

  final UserRepository userRepository = Get.put(UserRepository());


  Future<void> createUser(UserModel user) async {

    String UID = await AuthenticationRepository.instance.createUserWithEmailAndPassword(user.email ?? "",user.password ?? "");
    await userRepository.creatUser(user,UID);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, UID);
  }

}