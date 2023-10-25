import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:stormen/Constands/image_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';
import 'package:stormen/Repository/authentication_repository/authentication_repository.dart';
import 'package:stormen/Repository/user_repository/user_repository.dart';

class UpdateProfileController extends GetxController{
  static UpdateProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  File? selectedImage;
  final String key = 'myUIDKey';

  Future<void> updateUserProfile(UserModel2 userData) async {
    selectedImage = userData.image != null ? File(userData.image!) : null;
    final downloadURL = await uploadImage(selectedImage);

    if (downloadURL != null) {
      userData.image = downloadURL; // Assign the URL
      await updateRecord(userData);
    } else {
      // Handle the case where the image upload failed
    }
  }

  Future<String?> uploadImage(File? image) async {
    if (image == null) {
      print('Null');
      return null; // No image to upload
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString(key) ?? '';
      final Reference storageRef = FirebaseStorage.instance.ref().child('Profile_Picture/$uid');
      final UploadTask uploadTask = storageRef.putFile(image);
      final TaskSnapshot snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email);
    }else{
      Get.snackbar('Error', 'Login to continue');
    }
  }

  updateRecord(UserModel2 user) async{
    await _userRepo.updateUserRecord(user);
  }
}