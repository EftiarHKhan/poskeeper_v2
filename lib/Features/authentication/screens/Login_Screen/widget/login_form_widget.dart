import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/Features/authentication/controllers/login_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final LoginController loginController = Get.put(LoginController());

    return Form(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: loginController.email.value,
            decoration: InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user),
                labelText: tEmail,
                hintText: tEmail,
                border: OutlineInputBorder()),
          ),
          SizedBox(height: tFormHeight - 20),
          Obx(
            () => TextFormField(
              controller: loginController.pass.value,
              obscureText: loginController.e.value,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password_outlined),
                  labelText: tPassword,
                  hintText: tPassword,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: (){
                      loginController.eye();
                    },
                    icon: Obx(()=> loginController.e.value ? Icon(LineAwesomeIcons.eye):Icon(LineAwesomeIcons.eye_slash)),
                  )),
            ),
          ),
          SizedBox(height: tFormHeight - 20),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                  },
                  child: Text(tForgetPassword))),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    loginController.login();
                  }, child: Text(tLogin.toUpperCase()))
          ),

        ],
      ),
    ));
  }
}
