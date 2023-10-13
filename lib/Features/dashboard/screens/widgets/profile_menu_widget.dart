import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Constands/colors_strings.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key, required this.title, required this.icon, required this.onPress, this.endIcon = true, this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? tPrimaryColor : tAccentColor;
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: iconColor.withOpacity(0.1)
        ),
        child: Icon(icon,color: iconColor,),
      ),
      title: Text(title,style: GoogleFonts.mavenPro(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)?.apply(color: textColor),),
      trailing: endIcon? Container(
        width: 30,height: 30,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.grey.withOpacity(0.1)),
        child: Icon(LineAwesomeIcons.angle_right,size: 18,color: Colors.grey,),
      ) : null,
    );
  }
}
