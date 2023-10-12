import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Constands/colors_strings.dart';
import 'package:stormen/Constands/sizes_strings.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/Features/add_product/controllers/product_controller.dart';
import 'package:stormen/Utils/Widgets/appbar/home_appbar.dart';
import '../../../Utils/Widgets/sizebox/space_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    productController.databaseHelper = DatabaseHelper.instance;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhiteColor,
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(tProductName,style: TextStyle(color: tDarkColor,fontSize: tTextSize1,fontWeight: FontWeight.bold),),
              space(10),
              TextField(
                controller: productController.p_name,
                style: const TextStyle(color: tDarkColor),
                //obscureText: true, // It's for password
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      LineAwesomeIcons.pen,
                      color: tGrayCholor2,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(tButtonHeight),
                        borderSide:
                        const BorderSide(color: tBoarderLine)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(tButtonHeight),
                        borderSide:
                        const BorderSide(color: tGrayColor1)),
                    labelText: tHint1,
                    labelStyle:
                    const TextStyle(color: tGrayColor1)),
                cursorColor: tGrayColor2,
              ),
              space(25),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(tSale,style: TextStyle(color: tDarkColor,fontSize: tTextSize1,fontWeight: FontWeight.bold),),
                        space(10),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: productController.s_price,
                          style: const TextStyle(color: Colors.black),
                          //obscureText: true, // It's for password
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                LineAwesomeIcons.money_bill,
                                color: Colors.green,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent.shade200)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  const BorderSide(color: Color(0xff6F6F6F))),
                              labelText: tPrice,
                              labelStyle:
                              const TextStyle(color: Color(0xff6F6F6F))),
                          cursorColor: const Color(0xff9DB9DD),
                        ),
                      ],
                    ),
                  ),
                  space2(20),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(tPurchasePrice,style: TextStyle(color: tDarkColor,fontSize: tTextSize1,fontWeight: FontWeight.bold),),
                        space(10),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: productController.p_price,
                          style: const TextStyle(color: Colors.black),
                          //obscureText: true, // It's for password
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                LineAwesomeIcons.money_bill,
                                color: Colors.redAccent,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent.shade200)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  const BorderSide(color: Color(0xff6F6F6F))),
                              labelText: tPrice,
                              labelStyle:
                              const TextStyle(color: Color(0xff6F6F6F))),
                          cursorColor: const Color(0xff9DB9DD),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              space(30),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(tOpeningStock,style: TextStyle(color: tDarkColor,fontSize: tTextSize1,fontWeight: FontWeight.bold),),
                        space(10),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: productController.o_stock,
                          style: const TextStyle(color: Colors.black),
                          //obscureText: true, // It's for password
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent.shade200)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  const BorderSide(color: Color(0xff6F6F6F))),
                              labelText: tCount,
                              labelStyle:
                              const TextStyle(color: Color(0xff6F6F6F))),
                          cursorColor: const Color(0xff9DB9DD),
                        ),
                      ],
                    ),
                  ),
                  space2(20),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(tLowStock,style: TextStyle(color: tDarkColor,fontSize: tTextSize1,fontWeight: FontWeight.bold),),
                        space(10),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: productController.l_stock,
                          style: const TextStyle(color: Colors.black),
                          //obscureText: true, // It's for password
                          decoration: InputDecoration(
                              suffixIcon: const Icon(
                                LineAwesomeIcons.bell,
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent.shade200)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                  const BorderSide(color: Color(0xff6F6F6F))),
                              labelText: tCount,
                              labelStyle:
                              const TextStyle(color: Color(0xff6F6F6F))),
                          cursorColor: const Color(0xff9DB9DD),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              space(50),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.center,
                  //color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          productController.product_insert();
                        },
                        child: const Text(tSave,style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
