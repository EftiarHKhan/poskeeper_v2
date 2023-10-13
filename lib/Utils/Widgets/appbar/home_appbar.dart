import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../Features/about/screens/about_screen.dart';



HomeAppBar() {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Text('Stormen'),
    iconTheme: IconThemeData(color: Colors.black),
    actions: <Widget>[
      IconButton(
        onPressed: () {
          Get.to(About());
        },
        icon: Icon(LineAwesomeIcons.exclamation_circle, color: Colors.black),
      )
    ],
  );
}
