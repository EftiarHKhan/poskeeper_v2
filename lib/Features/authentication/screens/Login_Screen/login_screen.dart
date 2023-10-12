import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stormen/Constands/colors_strings.dart';
import 'package:stormen/Constands/image_strings.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Features/authentication/screens/Login_Screen/widget/login_form_widget.dart';
import 'package:stormen/Utils/Widgets/form/form_footer_widget.dart';
import 'package:stormen/Utils/Widgets/form/form_header_widget.dart';
import '../../../../constands/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: tWhiteColor,
            padding: EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FormHeaderWidget(image: tBannerImage4,title: tLoginTitle,subTitle: tLoginSubTitle,),
                LoginForm(),
                FormFooterWidget(normalText: tDontHaveAccount, RichText: tSign_Up)
              ],
            ),
          ),
        ),
      ),
    );
  }
}



