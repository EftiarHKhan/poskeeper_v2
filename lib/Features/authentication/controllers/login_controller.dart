import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stormen/Repository/authentication_repository/authentication_repository.dart';

class LoginController extends GetxController{


  final email = TextEditingController().obs;
  final pass = TextEditingController().obs;
  final RxBool e = true.obs;
  final RxBool Load = false.obs;
  final String key = 'myUIDKey';


  Future<void> login() async{

    String UID = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.value.text.toString().trim(), pass.value.text.toString().trim());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, UID);

  }

  eye(){
    if(e.value == true){
      e.value = false;
    }else{
      e.value=true;

    }
  }

}