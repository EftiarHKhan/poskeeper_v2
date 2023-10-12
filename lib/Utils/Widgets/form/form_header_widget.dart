import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    this.imageColor,
    this.imageHeight = 0.2,
    this.heightBetween,
    this.crossAxisAlignment=CrossAxisAlignment.start,
    this.textAlign});

  final String image,title,subTitle;
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(image: AssetImage(image),height: size.height * imageHeight,color: imageColor,),
        SizedBox(height: heightBetween,),
        Text(title,textAlign: textAlign,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        SizedBox(height: 8,),
        Text(subTitle,textAlign: textAlign,),
      ],
    );
  }
}
