import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stormen/Constands/text_strings.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/Features/add_product/controllers/image_picker_controller.dart';
import 'package:stormen/Features/add_product/model/product_model.dart';

class ProductController extends GetxController{

  final ImagePickerController im = Get.put(ImagePickerController());

  var p_name = TextEditingController();
  var s_price = TextEditingController();
  var p_price = TextEditingController();
  var o_stock = TextEditingController();
  var l_stock = TextEditingController();
  late DatabaseHelper databaseHelper;
  final now = new DateTime.now();
  File? selectedImage;
  final String key = 'myUIDKey';

  Future<void> updateUserProfile(Product product) async {
    selectedImage = product.image != null ? File(product.image!) : null;
    final downloadURL = await uploadImage(selectedImage,product.itemName);
    print(downloadURL);
    if (downloadURL != null) {
      product.image = downloadURL; // Assign the URL
      await databaseHelper.insertProduct(product);
    } else {
      // Handle the case where the image upload failed
    }
  }

  Future<String?> uploadImage(File? image,String name) async {
    if (image == null) {
      print('Null');
      return null; // No image to upload
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString(key) ?? '';
      final Reference storageRef = FirebaseStorage.instance.ref().child('Product_Picture').child('$uid/$name');
      final UploadTask uploadTask = storageRef.putFile(image);
      final TaskSnapshot snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }


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
      image: im.imagepath.value,
    );
    try {
      updateUserProfile(newProduct);

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
    im.imagepath.value = '';
  }

}