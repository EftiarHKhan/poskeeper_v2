import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/Features/add_product/model/product_model.dart';

class ProductController extends GetxController{

  var p_name = TextEditingController();
  var s_price = TextEditingController();
  var p_price = TextEditingController();
  var o_stock = TextEditingController();
  var l_stock = TextEditingController();
  late DatabaseHelper databaseHelper;
  final now = new DateTime.now();

  product_insert() async {
    double salePrice = double.tryParse(s_price.text) ?? 0;
    double purchasePrice = double.tryParse(p_price.text) ?? 0;
    int openingStock = int.tryParse(o_stock.text) ?? 0;
    int lowStock = int.tryParse(l_stock.text) ?? 0;

    await databaseHelper.initializeDatabase();

    final Product newProduct = Product(
      itemName: p_name.text,
      salePrice: salePrice,
      purchasePrice: purchasePrice,
      openingStock: openingStock,
      lowStock: lowStock,
      date: DateFormat('dd-MM-yyyy').format(now),
    );
    try {
      await databaseHelper.insertProduct(newProduct);
      clearAll();
      Get.snackbar(tProduct, tSuccess1);
    } catch (e) {
      Get.snackbar(tProduct, 'Error inserting product: $e');
    }

  }
  void clearAll(){
    p_name.clear();
    s_price.clear();
    p_price.clear();
    o_stock.clear();
    l_stock.clear();
  }

}