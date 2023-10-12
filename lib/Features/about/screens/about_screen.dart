import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/Widgets/appbar/home_appbar.dart';
import '../../../Utils/Widgets/sizebox/space_widget.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: AssetImage('assets/images/banner.jpg'),
                fit: BoxFit.cover,
              ),
              space(20),
              Text("B.M.Samiul Haque Real",style: GoogleFonts.mavenPro(fontSize: 20,fontWeight: FontWeight.bold),),
              space(20),
              Text("About Us",style: GoogleFonts.mavenPro(fontSize: 16),),
              space(5),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("We are diligent individuals. We like personality, timeliness, sincerity, and honesty.Passionate about creating mobile applications.",style: GoogleFonts.mavenPro(fontSize: 16),)),
              space(100),
              Text("Version : 1.0.1",style: GoogleFonts.mavenPro(fontSize: 14),),
              space(30),
              Text("© 2020-2025, Resoft LTD . All rights reserved",style: GoogleFonts.mavenPro(fontSize: 14),)
            ],
          ),
        ),
      ),
    );
  }
}
