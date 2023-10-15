import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';
import 'package:stormen/Repository/authentication_repository/authentication_repository.dart';
import 'package:stormen/Repository/user_repository/user_repository.dart';

class UpdateProfileController extends GetxController{
  static UpdateProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email);
    }else{
      Get.snackbar('Error', 'Login to continue');
    }
  }

  updateRecord(UserModel user) async{
    await _userRepo.updateUserRecord(user);
  }
}