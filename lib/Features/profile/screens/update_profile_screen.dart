import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Constands/colors_strings.dart';
import 'package:stormen/Constands/image_strings.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text('Edit Profile'),centerTitle: true,backgroundColor: tWhiteColor,),
      body: SingleChildScrollView(
        child: Container(
          color: tWhiteColor,
          padding: EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
            future: updateProfileController.getUserData(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  UserModel userData = snapshot.data as UserModel;
                  final name = TextEditingController(text: userData.fullname);
                  final email = TextEditingController(text: userData.email);
                  final pass = TextEditingController(text: userData.password);
                  final phone = TextEditingController(text: userData.phoneNo);
                  final storename = TextEditingController(text: userData.storeName);
                  return Column(
                    children: [
                      Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(borderRadius:BorderRadius.circular(100),child: Image(image: AssetImage(tProfileImage),)),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.blueAccent.shade200),
                                  child: Icon(LineAwesomeIcons.camera,color: tWhiteColor,size: 20,),
                                )),
                          ]
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
                            SizedBox(height: tFormHeight-20),
                            TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                label: Text(tEmail),
                                prefixIcon: Icon(LineAwesomeIcons.envelope),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: tFormHeight-20),
                            TextFormField(
                              controller: phone,
                              decoration: InputDecoration(
                                label: Text(tPhoneNo),
                                prefixIcon: Icon(LineAwesomeIcons.phone),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: tFormHeight-20),
                            TextFormField(
                              controller: pass,
                              decoration: InputDecoration(
                                label: Text(tPassword),
                                prefixIcon: Icon(Icons.password_outlined),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: tFormHeight-20),
                            TextFormField(
                              controller: storename,
                              decoration: InputDecoration(
                                label: Text(tStoreName),
                                prefixIcon: Icon(LineAwesomeIcons.alternate_store),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: tFormHeight-10),
                            Center(
                              child: SizedBox(
                                  width: 200,
                                  child: ElevatedButton(onPressed: () async {
                                    final userdata = UserModel(
                                        fullname: name.text.trim(),
                                        email: email.text.trim(),
                                        phoneNo: phone.text.trim(),
                                        password: pass.text.trim(),
                                        storeName: storename.text.trim());

                                    await updateProfileController.updateRecord(userdata);
                                  }, child: Text('Save'))),
                            )
                          ],
                        ),
                      )

                    ],
                  );
                }else if(snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()),);
                }else{
                  return const Center(child: Text('Something went wrong'),);
                }
              }else{
                return const Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        ),
      ),
    ));
  }
}
