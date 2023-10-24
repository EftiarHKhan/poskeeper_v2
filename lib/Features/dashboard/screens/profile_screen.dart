import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Constands/colors_strings.dart';
import 'package:stormen/Constands/image_strings.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/Features/Profile/screens/update_profile_screen.dart';
import 'package:stormen/Features/about/screens/about_screen.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';
import 'package:stormen/Features/dashboard/screens/widgets/profile_menu_widget.dart';
import 'package:stormen/Features/profile/controllers/update_controller.dart';
import 'package:stormen/Repository/authentication_repository/authentication_repository.dart';
import 'package:stormen/Utils/Widgets/sizebox/space_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final UpdateProfileController updateProfileController = Get.put(UpdateProfileController());

  @override
  void initState() {
    super.initState();
      setState(() {
        updateProfileController.getUserData();
      });
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: tWhiteColor,
            padding: EdgeInsets.all(tDefaultSize),
            child: FutureBuilder(
              future: updateProfileController.getUserData(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    UserModel2 userData = snapshot.data as UserModel2;
                    return Column(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(borderRadius:BorderRadius.circular(100),child: Image(image: AssetImage(tEmptyImage),)),
                        ),
                        space(10),
                        Text(userData.fullname.toString(),style: GoogleFonts.mavenPro(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                        Text(userData.email.toString(),style: GoogleFonts.mavenPro(color: Colors.black,fontSize: 15),),
                        space(20),
                        SizedBox(
                            width: 200,
                            child: ElevatedButton(onPressed: (){
                              Get.to(UpdateProfileScreen());
                            }, child: Text(tEditProfile,style: TextStyle(color: tWhiteColor),),style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade200,side: BorderSide.none,shape: StadiumBorder()
                            ),)),
                        SizedBox(height: 30,),
                        Divider(),
                        SizedBox(height: 30,),
                        ProfileMenuWidget(title: 'Settings', icon: LineAwesomeIcons.cog, onPress: () {Get.snackbar('Notice', 'Coming Soon...');},),
                        ProfileMenuWidget(title: 'Billing Details', icon: LineAwesomeIcons.wallet, onPress: () {Get.snackbar('Notice', 'Coming Soon...');},),
                        ProfileMenuWidget(title: 'User Management', icon: LineAwesomeIcons.user_check, onPress: () {Get.snackbar('Notice', 'Coming Soon...');},),
                        Divider(),
                        SizedBox(height: 10,),
                        ProfileMenuWidget(title: 'Information', icon: LineAwesomeIcons.info, onPress: () {Get.to(About());},),
                        ProfileMenuWidget(title: 'Logout',
                          icon: LineAwesomeIcons.alternate_sign_out,
                          textColor: Colors.red,
                          endIcon: false,
                          onPress: () {
                            Get.defaultDialog(
                              title: 'Logout',
                              titleStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                              titlePadding: EdgeInsets.only(top: 20),
                              contentPadding: EdgeInsets.all(20),
                              middleText: 'Your all data will remove after logout.Sync it before logout.\n\nAre you sure ?',
                              confirm: FilledButton(onPressed: () async {
                                Get.back();
                                AuthenticationRepository.instance.logout();
                              }, child: Text('Yes')),
                              cancel: OutlinedButton(onPressed: (){
                                Get.back();
                              },
                                  child: Text('No')),
                            );
                          },
                        ),
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
