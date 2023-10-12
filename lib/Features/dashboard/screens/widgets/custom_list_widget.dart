import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stormen/Constands/sizes_strings.dart';

Widget customlist(String text,String image) {
  return ListTile(
    title: Text(text,style: TextStyle(fontSize: tTextSize2),),
    leading: CircleAvatar(child: Image.asset(image)),
  );
}