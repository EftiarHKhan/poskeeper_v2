import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Features/dashboard/screens/widgets/custom_list_widget.dart';

import '../../../Constands/image_strings.dart';
import '../../../Constands/text_strings.dart';
import '../../../Utils/Widgets/sizebox/space_widget.dart';
import '../../add_product/screens/product_screen.dart';

class BuySellScreen extends StatefulWidget {
  const BuySellScreen({super.key});

  @override
  State<BuySellScreen> createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SvgPicture.asset(tBannerImage,height: tBannerSize),
          Text(tTitle1,style: TextStyle(fontWeight: FontWeight.bold,fontSize: tTextSize1),),
          space(tButtonHeight),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(tRedious),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 10,
                  )
                ]),
            child: Column(
              children: <Widget>[
                customlist(tList1,tListImage1),
                customlist(tList2,tListImage2),
                customlist(tList3,tListImage3),
              ],
            ),
          ),

        ],

      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: (){
              Get.to(AddProductScreen());
            },
            label: const Text(tAddProduct,style: TextStyle(color: Colors.white),),
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,),
            backgroundColor: Colors.green.shade500,
          )
        ],
      ),
    );
  }
}
