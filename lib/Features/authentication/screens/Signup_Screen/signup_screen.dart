import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stormen/Constands/colors_strings.dart';
import 'package:stormen/Constands/image_strings.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/Features/authentication/screens/Signup_Screen/widget/signup_form_widget.dart';
import 'package:stormen/Utils/Widgets/form/form_footer_widget.dart';
import 'package:stormen/Utils/Widgets/form/form_header_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: tWhiteColor,
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHeaderWidget(
                image: tBannerImage4,
                title: tSignUpTitle,
                subTitle: tSignUpSubTitle,
              ),
              SignUpForm(),
              FormFooterWidget(normalText: tAlreadyHaveAccount, RichText: tLogin)
            ],
          ),
        ),
      ),
    ));
  }
}


