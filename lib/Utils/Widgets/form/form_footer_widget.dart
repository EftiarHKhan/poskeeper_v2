import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stormen/Constands/colors_strings.dart';
import 'package:stormen/Constands/image_strings.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/Features/dashboard/screens/dashboard_screen.dart';


class FormFooterWidget extends StatelessWidget {
  const FormFooterWidget({super.key, required this.normalText, required this.RichText});

  final String normalText,RichText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        SizedBox(height: tFormHeight - 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Get.back();
              Get.to(DashboardScreen());
            },
            icon: Image(
              image: AssetImage(tGoogleLogoImage),
              width: 20,
            ),
            label: Text(tSignInWithGoogle.toUpperCase()),
          ),
        ),
        SizedBox(height: tFormHeight - 20),
        TextButton(onPressed: (){
        }, child: Text.rich(TextSpan(text: normalText,style: TextStyle(color: tSecondaryColor),
            children: [
              TextSpan(text: RichText,style: TextStyle(color: Colors.deepPurple))
            ])))
      ],
    );
  }
}
