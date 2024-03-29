
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:stormen/Constands/colors_strings.dart';

import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/Features/add_product/controllers/image_picker_controller.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';
import 'package:stormen/Features/profile/controllers/update_controller.dart';
import 'package:stormen/Utils/Widgets/sizebox/space_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final UpdateProfileController updateProfileController = Get.put(UpdateProfileController());
  final ImagePickerController im = Get.put(ImagePickerController());



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          centerTitle: true,
          backgroundColor: tWhiteColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: tWhiteColor,
            padding: EdgeInsets.all(tDefaultSize),
            child: FutureBuilder(
              future: updateProfileController.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel2 userData = snapshot.data as UserModel2;
                    final name = TextEditingController(text: userData.fullname);
                    final email = TextEditingController(text: userData.email);
                    final pass = TextEditingController(text: userData.password);
                    final phone = TextEditingController(text: userData.phoneNo);
                    final storename = TextEditingController(text: userData.storeName);
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Get.defaultDialog(
                              title: 'Pick a image',
                              titleStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                              titlePadding: EdgeInsets.only(top: 20),
                              contentPadding: EdgeInsets.all(20),
                              middleText: 'Do you want to pick a image?',
                              confirm: OutlinedButton(onPressed: () async {
                                Get.back();
                                im.camera();
                              }, child: Text('Pick from Camera')),
                              cancel: FilledButton(onPressed: (){
                                Get.back();
                                im.gallery();
                              },
                                  child: Text('Pick from Gellary')),
                            );
                          },
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: userData.image != null && userData.image!.isNotEmpty
                                        ? NetworkImage(userData.image!)
                                        : null, // Null if no image URL is provided
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.blueAccent.shade200,
                                  ),
                                  child: Icon(LineAwesomeIcons.camera, color: tWhiteColor, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        space(50),
                        Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                  label: Text(tFullName),
                                  prefixIcon: Icon(LineAwesomeIcons.user),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                  label: Text(tEmail),
                                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: phone,
                                decoration: InputDecoration(
                                  label: Text(tPhoneNo),
                                  prefixIcon: Icon(LineAwesomeIcons.phone),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: pass,
                                decoration: InputDecoration(
                                  label: Text(tPassword),
                                  prefixIcon: Icon(Icons.password_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: storename,
                                decoration: InputDecoration(
                                  label: Text(tStoreName),
                                  prefixIcon: Icon(LineAwesomeIcons.alternate_store),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: tFormHeight - 10),
                              Center(
                                child: SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final userdata = UserModel2(
                                        fullname: name.text.trim(),
                                        email: email.text.trim(),
                                        phoneNo: phone.text.trim(),
                                        password: pass.text.trim(),
                                        storeName: storename.text.trim(),
                                        image: im.imagepath.value, // Include the UID
                                      );

                                      await updateProfileController.updateUserProfile(userdata);
                                    },
                                    child: Text('Save'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text('Something went wrong'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
