import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Features/dashboard/controllers/stock_controller.dart';
import 'package:stormen/Features/profile/controllers/update_controller.dart';
import 'package:stormen/Utils/Widgets/sizebox/space_widget.dart';


class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> with SingleTickerProviderStateMixin{

  final StockController stockController = Get.put(StockController());
  final UpdateProfileController updateProfileController = Get.put(UpdateProfileController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Initialize the database
    stockController.databaseHelper.initializeDatabase().then((_) {
      // Fetch data from the database
      stockController.fetchData();
      setState(() {
        updateProfileController.getUserData();
      });
    });

    // Initialize the TabController
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the TabController
    _tabController.dispose();
    super.dispose();
  }

  // This function is called whenever the text field changes


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Obx(()=> Text('৳ ${stockController.totalStockAmount.value.toString()}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)),
                                space(5),
                                Text("Total Stock Value",style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Obx(()=> Text(stockController.lowStockCount.value.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),)),
                                space(5),
                                Text("Low Stock Items",style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => stockController.runFilter(value),
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                hintText: "Search",
                suffixIcon: const Icon(Icons.search),
                // prefix: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
          TabBar(
            tabs: [
              Tab(
                text: "All Products", // Add the tab name for the first tab
              ),
              Tab(
                text: "Low Stock", // Add the tab name for the second tab
              ),
            ],
            controller: _tabController, // Provide the TabController
          ),
          space(10),
          Expanded(
            child: TabBarView(
              controller: _tabController, // Use the TabController here
              children: [
                // First Tab: List of Products
                stockController.foundUsers.isNotEmpty
                    ? Obx(()=>ListView.builder(
                  itemCount: stockController.foundUsers.length,
                  itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(position: index,
                          child:SlideAnimation(
                            child: FadeInAnimation(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      showModalBottomSheet(context: context,
                                          builder: (BuildContext context){
                                            return SizedBox(
                                              height: 415,
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(padding: EdgeInsets.only(top: 10)),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Item Name",style: TextStyle(color: Colors.grey.shade800),),
                                                                Text(stockController.foundUsers[index].itemName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [Image.file(File(stockController.foundUsers[index].image),width: 100,height: 100,)
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      space(20),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Sale Price",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                                Text("৳ ${stockController.foundUsers[index].salePrice.toString()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Purchase Price",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                                Text("৳ ${stockController.foundUsers[index].purchasePrice.toString()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Stock Quantity",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                                Text(stockController.foundUsers[index].openingStock.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      space(15),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Stock Value",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                                Text("৳ ${stockController.foundUsers[index].purchasePrice * stockController.foundUsers[index].openingStock}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Units",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                                Text("NOS",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Low Stock Alert",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                                Text(stockController.foundUsers[index].lowStock.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      space(30),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: ElevatedButton(style: ElevatedButton.styleFrom(
                                                          primary: Colors.blueAccent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                        ),onPressed: () async {
                                                          Get.back();
                                                          showModalBottomSheet(context: context,builder: (BuildContext context){
                                                            return SizedBox(
                                                                height: 600,
                                                                width: double.infinity,
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(15),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      space(5),
                                                                      Text("Product Name : ${stockController.foundUsers[index].itemName}",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                                                                      space(10),
                                                                      Text("Enter Quantity of sold items",style: TextStyle(color: Colors.grey.shade800,fontSize: 15)),
                                                                      space(10),
                                                                      TextField(
                                                                        controller: stockController.p_quantity,
                                                                        keyboardType: TextInputType.number,
                                                                        style: TextStyle(color: Colors.black,fontSize: 40.0),
                                                                        decoration: InputDecoration(
                                                                          hintText: '0 NOS',
                                                                          hintStyle: TextStyle(fontSize: 40.0),
                                                                          // Adjust the fontSize here
                                                                        ),
                                                                        cursorColor: Color(0xff6F6F6F),
                                                                      ),
                                                                      space(20),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Text("Sale Price",style: TextStyle(color: Colors.grey.shade800,fontSize: 15),),
                                                                            space(10),
                                                                            TextField(
                                                                              controller: stockController.s_pr,
                                                                              keyboardType: TextInputType.number,
                                                                              style: TextStyle(color: Colors.black),
                                                                              //obscureText: true, // It's for password
                                                                              decoration: InputDecoration(
                                                                                  prefixIcon: Icon(
                                                                                    LineAwesomeIcons.alternate_wavy_money_bill,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                      borderSide:
                                                                                      BorderSide(color: Colors.blueAccent.shade200)),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                      borderSide:
                                                                                      BorderSide(color: Color(0xff6F6F6F))),
                                                                                  labelText: "Enter Amount",
                                                                                  labelStyle:
                                                                                  TextStyle(color: Color(0xff6F6F6F))),
                                                                              cursorColor: Color(0xff9DB9DD),
                                                                            ),
                                                                            space(25),
                                                                            SizedBox(
                                                                                width: double.infinity,
                                                                                child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      primary: Colors.blue,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                      ),),
                                                                                    onPressed: () async {
                                                                                      Get.back();
                                                                                      stockController.sell_product(index);
                                                                                      Get.snackbar('Notice', 'Product Selled');

                                                                                }, child: Text("CONFIRM",style: TextStyle(color: Colors.white),)))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            );
                                                          });


                                                        }, child: Text("SELL",style: TextStyle(color: Colors.white),)),
                                                      ),
                                                      space(10),
                                                      Row(
                                                        children: [
                                                          Expanded(flex:1,child: ElevatedButton(style: ElevatedButton.styleFrom(
                                                            primary: Colors.green,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),onPressed: (){
                                                            Navigator.of(context).pop();
                                                            showModalBottomSheet(context: context, builder: (BuildContext context){
                                                              return SingleChildScrollView(
                                                                child: SizedBox(
                                                                  height: 600,
                                                                  width: double.infinity,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(15),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Padding(padding: EdgeInsets.only(top: 10)),
                                                                        Text("Product Name",style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold),),
                                                                        space(10),
                                                                        TextField(
                                                                          controller: stockController.p_name,
                                                                          style: TextStyle(color: Colors.black),
                                                                          //obscureText: true, // It's for password
                                                                          decoration: InputDecoration(
                                                                              prefixIcon: Icon(
                                                                                LineAwesomeIcons.pen,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  borderSide:
                                                                                  BorderSide(color: Colors.blueAccent.shade200)),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  borderSide:
                                                                                  BorderSide(color: Color(0xff6F6F6F))),
                                                                              labelText: stockController.foundUsers[index].itemName,
                                                                              labelStyle:
                                                                              TextStyle(color: Color(
                                                                                  0xff313131))),
                                                                          cursorColor: Color(0xff6F6F6F),
                                                                        ),
                                                                        space(15),
                                                                        Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text("Sale Price",style: TextStyle(color: Colors.grey.shade600,fontSize: 16,fontWeight: FontWeight.bold),),
                                                                                  space(10),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType.number,
                                                                                    controller: stockController.s_price,
                                                                                    style: TextStyle(color: Colors.black),
                                                                                    //obscureText: true, // It's for password
                                                                                    decoration: InputDecoration(
                                                                                        prefixIcon: Icon(
                                                                                          LineAwesomeIcons.alternate_wavy_money_bill,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            borderSide:
                                                                                            BorderSide(color: Colors.blueAccent.shade200)),
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            borderSide:
                                                                                            BorderSide(color: Color(0xff6F6F6F))),
                                                                                        labelText: stockController.foundUsers[index].salePrice.toString(),
                                                                                        labelStyle:
                                                                                        TextStyle(color: Color(0xff6F6F6F))),
                                                                                    cursorColor: Color(0xff9DB9DD),
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
                                                                                  Text("Purchase Price",style: TextStyle(color: Colors.grey.shade600,fontSize: 16,fontWeight: FontWeight.bold),),
                                                                                  space(10),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType.number,
                                                                                    controller: stockController.p_price,
                                                                                    style: TextStyle(color: Colors.black),
                                                                                    //obscureText: true, // It's for password
                                                                                    decoration: InputDecoration(
                                                                                        prefixIcon: Icon(
                                                                                          LineAwesomeIcons.alternate_wavy_money_bill,
                                                                                          color: Colors.redAccent,
                                                                                        ),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            borderSide:
                                                                                            BorderSide(color: Colors.blueAccent.shade200)),
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            borderSide:
                                                                                            BorderSide(color: Color(0xff6F6F6F))),
                                                                                        labelText: stockController.foundUsers[index].purchasePrice.toString(),
                                                                                        labelStyle:
                                                                                        TextStyle(color: Color(0xff6F6F6F))),
                                                                                    cursorColor: Color(0xff6F6F6F),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        space(15),
                                                                        Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text("Opening Stock",style: TextStyle(color: Colors.grey.shade600,fontSize: 16,fontWeight: FontWeight.bold),),
                                                                                  space(10),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType.number,
                                                                                    controller: stockController.o_stock,
                                                                                    style: TextStyle(color: Colors.black),
                                                                                    //obscureText: true, // It's for password
                                                                                    decoration: InputDecoration(
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            borderSide:
                                                                                            BorderSide(color: Colors.blueAccent.shade200)),
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            borderSide:
                                                                                            BorderSide(color: Color(0xff6F6F6F))),
                                                                                        labelText: stockController.foundUsers[index].openingStock.toString(),
                                                                                        labelStyle:
                                                                                        TextStyle(color: Color(0xff6F6F6F))),
                                                                                    cursorColor: Color(0xff9DB9DD),
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
                                                                                  Text("Low Stock Alert",style: TextStyle(color: Colors.grey.shade600,fontSize: 16,fontWeight: FontWeight.bold),),
                                                                                  space(10),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType.number,
                                                                                    controller: stockController.l_stock,
                                                                                    style: TextStyle(color: Colors.black),
                                                                                    //obscureText: true, // It's for password
                                                                                    decoration: InputDecoration(
                                                                                        suffixIcon: Icon(
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
                                                                                            BorderSide(color: Color(0xff6F6F6F))),
                                                                                        labelText: stockController.foundUsers[index].lowStock.toString(),
                                                                                        labelStyle:
                                                                                        TextStyle(color: Color(0xff6F6F6F))),
                                                                                    cursorColor: Color(0xff9DB9DD),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        space(15),
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Container(
                                                                            alignment: Alignment.center,
                                                                            //color: Colors.white,
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  primary: Colors.green,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                ),
                                                                                onPressed: () async {
                                                                                  stockController.update_product(index);
                                                                                },
                                                                                child: Text("CONFIRM",style: TextStyle(color: Colors.white),)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                          }, child: Text("UPDATE",style: TextStyle(color: Colors.white),))),
                                                          space2(10),
                                                          Expanded(flex:1,child: ElevatedButton(style: ElevatedButton.styleFrom(
                                                            primary: Colors.red,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),onPressed: () async {
                                                            Get.defaultDialog(
                                                              title: 'Confirm the action',
                                                              titleStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                                                              titlePadding: EdgeInsets.only(top: 20),
                                                              contentPadding: EdgeInsets.all(20),
                                                              middleText: 'Do you really want to delete this product?',
                                                              confirm: FilledButton(onPressed: () async {
                                                                Get.back();
                                                                Get.back();
                                                                await stockController.deleteProduct(stockController.foundUsers[index].id);
                                                              }, child: Text('CONFIRM')),
                                                              cancel: OutlinedButton(onPressed: (){
                                                                Get.back();
                                                              },
                                                                  child: Text('CANCEL')),
                                                            );

                                                          }, child: Text("DELETE",style: TextStyle(color: Colors.white),))),
                                                        ],)

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.indigo.shade700,
                                        ),
                                        child: Row(children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  stockController.foundUsers[index].itemName,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      LineAwesomeIcons.alternate_wavy_money_bill,
                                                      color: Colors.grey[200],
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Purchase Price : ${stockController.foundUsers[index].purchasePrice}",
                                                      style: GoogleFonts.lato(
                                                        textStyle:
                                                        TextStyle(fontSize: 13, color: Colors.grey[100]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  "Sale Price : ${stockController.foundUsers[index].salePrice} , Current Stock : ${stockController.foundUsers[index].openingStock}",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                            height: 60,
                                            width: 1.0,
                                            color: Colors.white!.withOpacity(0.7),
                                          ),
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              stockController.foundUsers[index].date,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      );
                  },
                ),
                    )
                    : Center(
                  child: Text('No products available.'),
                ),
                // Second Tab: Normal Text
                stockController.lowstock_list.isNotEmpty
                    ? Obx(()=> ListView.builder(
                  itemCount: stockController.lowstock_list.length,
                  itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(position: index,
                          child:SlideAnimation(
                            child: FadeInAnimation(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      showModalBottomSheet(context: context,
                                          builder: (BuildContext context){
                                            return SizedBox(
                                              height: 400,
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(padding: EdgeInsets.only(top: 10)),
                                                    Text("Item Name",style: TextStyle(color: Colors.grey.shade800),),
                                                    Text(stockController.lowstock_list[index].itemName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                    space(20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Sale Price",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                              Text("৳ ${stockController.lowstock_list[index].salePrice.toString()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Purchase Price",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                              Text("৳ ${stockController.lowstock_list[index].purchasePrice.toString()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Stock Quantity",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                              Text(stockController.lowstock_list[index].openingStock.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    space(15),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Stock Value",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                              Text("৳ ${stockController.lowstock_list[index].purchasePrice * stockController.lowstock_list[index].openingStock}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Units",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                              Text("NOS",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Low Stock Alert",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                                              Text(stockController.lowstock_list[index].lowStock.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    space(50),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(style: ElevatedButton.styleFrom(
                                                        primary: Colors.green,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                      ),onPressed: (){
                                                        Get.back();
                                                        showModalBottomSheet(context: context, builder: (BuildContext context){
                                                          return SingleChildScrollView(
                                                            child: SizedBox(
                                                              height: 600,
                                                              width: double.infinity,
                                                              child: Padding(
                                                                padding: EdgeInsets.all(15),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Padding(padding: EdgeInsets.only(top: 10)),
                                                                    Text("Product Name",style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold),),
                                                                    space(10),
                                                                    TextField(
                                                                      controller: stockController.p_name,
                                                                      style: TextStyle(color: Colors.black),
                                                                      //obscureText: true, // It's for password
                                                                      decoration: InputDecoration(
                                                                          prefixIcon: Icon(
                                                                            LineAwesomeIcons.pen,
                                                                            color: Colors.grey,
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              borderSide:
                                                                              BorderSide(color: Colors.blueAccent.shade200)),
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              borderSide:
                                                                              BorderSide(color: Color(0xff6F6F6F))),
                                                                          labelText: stockController.foundUsers[index].itemName,
                                                                          labelStyle:
                                                                          TextStyle(color: Color(
                                                                              0xff313131))),
                                                                      cursorColor: Color(0xff6F6F6F),
                                                                    ),
                                                                    space(15),
                                                                    Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Text("Sale Price",style: TextStyle(color: Colors.grey.shade800,fontSize: 13,fontWeight: FontWeight.bold),),
                                                                              space(10),
                                                                              TextField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: stockController.s_price,
                                                                                style: TextStyle(color: Colors.black),
                                                                                //obscureText: true, // It's for password
                                                                                decoration: InputDecoration(
                                                                                    prefixIcon: Icon(
                                                                                      LineAwesomeIcons.alternate_wavy_money_bill,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                    focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide:
                                                                                        BorderSide(color: Colors.blueAccent.shade200)),
                                                                                    enabledBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide:
                                                                                        BorderSide(color: Color(0xff6F6F6F))),
                                                                                    labelText: stockController.foundUsers[index].salePrice.toString(),
                                                                                    labelStyle:
                                                                                    TextStyle(color: Color(0xff6F6F6F))),
                                                                                cursorColor: Color(0xff9DB9DD),
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
                                                                              Text("Purchase Price",style: TextStyle(color: Colors.grey.shade800,fontSize: 13,fontWeight: FontWeight.bold),),
                                                                              space(10),
                                                                              TextField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: stockController.p_price,
                                                                                style: TextStyle(color: Colors.black),
                                                                                //obscureText: true, // It's for password
                                                                                decoration: InputDecoration(
                                                                                    prefixIcon: Icon(
                                                                                      LineAwesomeIcons.alternate_wavy_money_bill,
                                                                                      color: Colors.redAccent,
                                                                                    ),
                                                                                    focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide:
                                                                                        BorderSide(color: Colors.blueAccent.shade200)),
                                                                                    enabledBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide:
                                                                                        BorderSide(color: Color(0xff6F6F6F))),
                                                                                    labelText: stockController.foundUsers[index].purchasePrice.toString(),
                                                                                    labelStyle:
                                                                                    TextStyle(color: Color(0xff6F6F6F))),
                                                                                cursorColor: Color(0xff6F6F6F),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    space(15),
                                                                    Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Text("Opening Stock",style: TextStyle(color: Colors.grey.shade800,fontSize: 13,fontWeight: FontWeight.bold),),
                                                                              space(10),
                                                                              TextField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: stockController.o_stock,
                                                                                style: TextStyle(color: Colors.black),
                                                                                //obscureText: true, // It's for password
                                                                                decoration: InputDecoration(
                                                                                    focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide:
                                                                                        BorderSide(color: Colors.blueAccent.shade200)),
                                                                                    enabledBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        borderSide:
                                                                                        BorderSide(color: Color(0xff6F6F6F))),
                                                                                    labelText: stockController.foundUsers[index].openingStock.toString(),
                                                                                    labelStyle:
                                                                                    TextStyle(color: Color(0xff6F6F6F))),
                                                                                cursorColor: Color(0xff9DB9DD),
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
                                                                              Text("Low Stock Alert",style: TextStyle(color: Colors.grey.shade800,fontSize: 13,fontWeight: FontWeight.bold),),
                                                                              space(10),
                                                                              TextField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: stockController.l_stock,
                                                                                style: TextStyle(color: Colors.black),
                                                                                //obscureText: true, // It's for password
                                                                                decoration: InputDecoration(
                                                                                    suffixIcon: Icon(
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
                                                                                        BorderSide(color: Color(0xff6F6F6F))),
                                                                                    labelText: stockController.foundUsers[index].lowStock.toString(),
                                                                                    labelStyle:
                                                                                    TextStyle(color: Color(0xff6F6F6F))),
                                                                                cursorColor: Color(0xff9DB9DD),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    space(15),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(10.0),
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        //color: Colors.white,
                                                                        child: SizedBox(
                                                                          width: double.infinity,
                                                                          child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                primary: Colors.green,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                              ),
                                                                              onPressed: () async {
                                                                                stockController.update_product(index);
                                                                              },
                                                                              child: Text("CONFIRM",style: TextStyle(color: Colors.white),)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                      }, child: Text("UPDATE",style: TextStyle(color: Colors.white),)),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.indigo.shade700,
                                        ),
                                        child: Row(children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  stockController.lowstock_list[index].itemName,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      LineAwesomeIcons.alternate_wavy_money_bill,
                                                      color: Colors.grey[200],
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Purchase Price : ${stockController.lowstock_list[index].purchasePrice}",
                                                      style: GoogleFonts.lato(
                                                        textStyle:
                                                        TextStyle(fontSize: 13, color: Colors.grey[100]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  "Sale Price : ${stockController.lowstock_list[index].salePrice} , Current Stock : ${stockController.lowstock_list[index].openingStock}",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                            height: 60,
                                            width: 1.0,
                                            color: Colors.white!.withOpacity(0.7),
                                          ),
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              stockController.lowstock_list[index].date,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      );
                  },
                ),
                    )
                    : Center(
                  child: Text('No products available.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

