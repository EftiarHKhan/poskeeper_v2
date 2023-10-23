import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/Features/authentication/controllers/signup_controller.dart';
import 'package:stormen/Features/authentication/model/user_model.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: tFormHeight-10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullName,
              decoration: InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(LineAwesomeIcons.user),
                  border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: tFormHeight-20),
            TextFormField(
              controller: controller.email,
              decoration: InputDecoration(
                  label: Text(tEmail),
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: tFormHeight-20),
            TextFormField(
              controller: controller.phoneNo,
              decoration: InputDecoration(
                  label: Text(tPhoneNo),
                  prefixIcon: Icon(LineAwesomeIcons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: tFormHeight-20),
            TextFormField(
              controller: controller.password,
              decoration: InputDecoration(
                  label: Text(tPassword),
                  prefixIcon: Icon(Icons.password_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          SizedBox(height: tFormHeight-20),
          TextFormField(
            controller: controller.storename,
            decoration: InputDecoration(
              label: Text(tStoreName),
              prefixIcon: Icon(LineAwesomeIcons.alternate_store),
              border: OutlineInputBorder(),
            ),
          ),
            SizedBox(height: tFormHeight-10),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  if(_formKey.currentState!.validate()){
                    final user = UserModel2(fullname: controller.fullName.text.trim(), email: controller.email.text.trim(), phoneNo: controller.phoneNo.text.trim(), password: controller.password.text.trim(), storeName: controller.storename.text.trim(),image: '#');
                    SignUpController.instance.createUser(user);
                  }
                }, child: Text(tSign_Up.toUpperCase())))
          ],
        ),
      ),
    );
  }
}