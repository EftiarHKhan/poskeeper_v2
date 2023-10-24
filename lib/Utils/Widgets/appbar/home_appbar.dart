import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Features/about/screens/about_screen.dart';



HomeAppBar() {
  final String key2 = 'storeName';
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    title: FutureBuilder<String>(
      future: SharedPreferences.getInstance().then((prefs) => prefs.getString(key2) ?? 'Stormen'), // Provide a default value if data is null
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(snapshot.data ?? 'Stormen', style: TextStyle(color: Colors.black)); // Provide a default loading text
        } else {
          return Text(snapshot.data ?? 'Stormen', style: TextStyle(color: Colors.black)); // Provide a default title if data is null
        }
      },
    ),
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
