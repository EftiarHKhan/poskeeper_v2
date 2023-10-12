import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/DB_Helper/sell_product/sell_db.dart';
import 'package:stormen/Features/add_product/model/product_model.dart';
import 'package:stormen/Features/sell_product/model/sell_product_model.dart';

class StockController extends GetxController{

  DatabaseHelperSell databaseHelperSell = DatabaseHelperSell.instance;
  final RxDouble totalStockAmount = 0.0.obs;
  final RxInt lowStockCount = 0.obs;
  RxList<Product> productList = RxList<Product>();
  RxList<Product> foundUsers = RxList<Product>();
  RxList<Product> lowstock_list = RxList<Product>();
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  var p_name = TextEditingController();
  var s_price = TextEditingController();
  var p_price = TextEditingController();
  var o_stock = TextEditingController();
  var l_stock = TextEditingController();
  var p_quantity = TextEditingController();
  var s_pr = TextEditingController();
  final now = new DateTime.now();

  void sell_product(int index){
    double salePrice = double.tryParse(s_pr.text) ?? 0;
    double pp = double.tryParse(p_price.text) ?? 0;
    int quantityAmount = int.tryParse(p_quantity.text) ?? 0;
    double FinalPrice = salePrice * quantityAmount ;

    final SellProduct newProduct = SellProduct(
        ProductName: foundUsers[index].itemName,
        SalePrice: salePrice,
        Quentity: quantityAmount,
        FinalPrice: FinalPrice,
        date: DateFormat('dd-MM-yyyy').format(now),
        Purchaseprice: foundUsers[index].purchasePrice,
    );

    _sellProduct(newProduct);
  }

  void update_product(int index){
    double salePrice = double.tryParse(s_price.text) ?? foundUsers[index].salePrice;
    double purchasePrice = double.tryParse(p_price.text) ?? foundUsers[index].purchasePrice;
    int openingStock = int.tryParse(o_stock.text) ??  foundUsers[index].openingStock;
    int lowStock = int.tryParse(l_stock.text) ??  foundUsers[index].lowStock;
    int id_no = foundUsers[index].id;
    String itemname = p_name.text;
    if (itemname.isNotEmpty){
      itemname = p_name.text;
    }else{
      itemname = foundUsers[index].itemName;
    }
    updateProduct(id_no,itemname,salePrice,purchasePrice,openingStock,lowStock);
    Get.back();
    Get.snackbar('Update', 'Product updated successfully');
  }



  Future<void> _sellProduct(SellProduct newProduct) async {
    await databaseHelperSell.insertProduct(newProduct); // Delete the product from the database
    // Reload the list of products from the database
    await fetchData();
    foundUsers.assignAll(productList);

  }
  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // If the search field is empty, display all products
      foundUsers.assignAll(productList);
      lowstock_list.assignAll(productList.where((product) => product.openingStock <= product.lowStock).toList());
    } else {
      foundUsers.assignAll(productList.where((product) => product.itemName.toLowerCase().contains(enteredKeyword.toLowerCase())).toList());
      lowstock_list.assignAll(productList.where((product) => product.itemName.toLowerCase().contains(enteredKeyword.toLowerCase()) && product.openingStock <= product.lowStock).toList());
    }
  }
  Future<void> deleteProduct(int id) async {
    await databaseHelperSell.delete(id); // Delete the product from the database
    await fetchData();
    foundUsers.assignAll(productList);
  }
  Future<void> updateProduct(int id ,String itemName,double salePrice,double purchasePrice,int openingStock,int lowStock ) async {
    await databaseHelperSell.update(id, itemName, salePrice, purchasePrice, openingStock, lowStock);
    await fetchData();
    foundUsers.assignAll(productList);
  }

  Future<void> fetchData() async {
    productList.assignAll(await databaseHelper.queryAllProducts());
    foundUsers.assignAll(productList);
    lowstock_list.assignAll(productList.where((product) => product.openingStock <= product.lowStock).toList());
    calculateTotalStockAmount(foundUsers);
    countLowStockProducts(foundUsers);
  }

  void calculateTotalStockAmount(List<Product> productList) {
    totalStockAmount.value = 0.0;
    for (Product product in productList) {
      // Check if the product is a stock product based on openingStock
      if (product.openingStock > 0) {
        totalStockAmount.value += (product.openingStock * product.purchasePrice);
      }
    }
  }

  void countLowStockProducts(List<Product> productList) {
    lowStockCount.value = 0;
    for (Product product in productList) {
      if (product.openingStock <= product.lowStock) {
        lowStockCount.value++;
      }
    }
  }

}