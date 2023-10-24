import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stormen/Features/sell_product/model/sell_product_model.dart';

class DatabaseHelperSell {
  late Database _database;
  late Database _database2;
  final String key = 'myUIDKey';

  static final DatabaseHelperSell instance = DatabaseHelperSell._privateConstructor();

  DatabaseHelperSell._privateConstructor();

  Future<void> initializeDatabase() async {
    final String path1 = await getDatabasesPath();
    final String databasePath1 = join(path1, 'Asellproductlist10.db');

    final String path2 = await getDatabasesPath();
    final String databasePath2 = join(path2, 'allproductinsert1.db');

    bool exist1 = await databaseExists(databasePath1);
    bool exist2 = await databaseExists(databasePath2);

    if (!exist1) {
      _database = await openDatabase(
        databasePath1,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE sellproduct(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              itemName TEXT,
              salePrice DOUBLE,
              quantity INTEGER,
              finalPrice DOUBLE,
              date TEXT,
              purchaseprice DOUBLE
            )
          ''');
        },
      );
    } else {
      _database = await openDatabase(databasePath1);
    }
    if (!exist2) {
      print('No Database');
    } else {
      _database2 = await openDatabase(databasePath2);
    }
  }

  Future<void> SellsyncDataToFirebase(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(key) ?? '';
    DatabaseReference firebaseRef = FirebaseDatabase.instance.reference().child(uid).child('Sell_Product');

    try {
      // Query all sell products from SQLite
      final List<SellProduct> sellProducts = await queryAllProducts();
      if (sellProducts.isEmpty) {
        await syncSellProductsDataToLocalDatabase(context);
      }else{
        // Query all sell products from Firebase and remove them
        await firebaseRef.remove();
        // Iterate through each sell product and sync it with Firebase
        for (SellProduct product in sellProducts) {
          try {
            // Insert the sell product as a new record in Firebase
            await firebaseRef.child("${product.id.toString()}-${product.ProductName.toString()}").set(product.toMap());
          } catch (error) {
            print('Error syncing sell product to Firebase: ${error.toString()}');
          }
        }
        Get.snackbar('Notice', 'Sell-List Sync Successfully');
      }

    } catch (error) {
      print('Error removing existing sell data from Firebase: ${error.toString()}');
    }
  }


  Future<void> insertProduct(SellProduct sellProduct) async {
    await _database.insert(
      'sellproduct',
      sellProduct.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _updateStock(sellProduct.ProductName, sellProduct.Quentity);

  }
  Future<void> update(int id ,String itemName,double salePrice,double purchasePrice,int openingStock,int lowStock ) async {
    await _database2.update(
      'allproduct',
      {
        'itemName': itemName,
        'salePrice': salePrice,
        'purchasePrice': purchasePrice,
        'openingStock': openingStock,
        'lowStock': lowStock,
      },
      where: 'id = ?', // Use the 'id' field to uniquely identify the product
      whereArgs: [id], // Use the id of the earliest product
    );
    Get.snackbar('Update', 'Product successfully Updated');
  }
  Future<void> delete(int id) async {
    await _database2.delete(
      'allproduct',
      where: 'id = ?',
      whereArgs: [id],
    );
    Get.snackbar('Delete', 'Product successfully deleted');
  }

  Future<void> deleteAllProductData() async {
    if (_database != null) {
      await _database.delete('sellproduct');
    }
    if (_database2 != null) {
      await _database2.delete('allproduct');
    }
  }


  Future<void> _updateStock(String itemName, int quantitySold) async {
    // Get the current stock for the given product
    final currentStock = await _getCurrentStock(itemName);
    final lowStock = await _getLowStock(itemName);

    // Calculate the new stock after subtracting the quantity sold
    final newStock = currentStock - quantitySold;

    final products = await _database2.query(
      'allproduct',
      where: 'itemName = ?',
      whereArgs: [itemName],
      orderBy: 'date ASC', // Order by insertion date in ascending order
    );

    if (products.isNotEmpty) {
      final earliestProduct = products.first;
      if(newStock <= 0){
        await _database2.delete(
          'allproduct',
          where: 'id = ?', // Use the 'id' field to uniquely identify the product
          whereArgs: [earliestProduct['id']],
        );
      }else if(newStock <= lowStock ){

        Get.snackbar('Stock Limit', 'Only ${newStock} left in stock');
      }
    }

    if (products.isNotEmpty) {
      final earliestProduct = products.first;
      await _database2.update(
        'allproduct',
        {'openingStock': newStock},
        where: 'id = ?', // Use the 'id' field to uniquely identify the product
        whereArgs: [earliestProduct['id']], // Use the id of the earliest product
      );
    }
  }

  Future<int> _getCurrentStock(String itemName) async {
    final result = await _database2.query(
      'allproduct',
      columns: ['openingStock'],
      where: 'itemName = ?',
      whereArgs: [itemName],
    );

    if (result.isNotEmpty) {
      return result.first['openingStock'] as int;
    } else {
      throw Exception('Product not found in the allproduct table');
    }
  }
  Future<int> _getLowStock(String itemName) async {
    final result = await _database2.query(
      'allproduct',
      columns: ['lowStock'],
      where: 'itemName = ?',
      whereArgs: [itemName],
    );

    if (result.isNotEmpty) {
      return result.first['lowStock'] as int;
    } else {
      throw Exception('Product not found in the allproduct table');
    }
  }

  Future<List<SellProduct>> queryAllProducts() async {
    List<Map<String, dynamic>> maps = await _database.query('sellproduct');

    // Generate the list of products in ascending order by default
    List<SellProduct> productList = List.generate(maps.length, (index) {
      return SellProduct(
          ProductName: maps[index]['itemName'],
          SalePrice: maps[index]['salePrice'] ?? 0,
          Quentity: maps[index]['quantity'] ?? 0,
          FinalPrice: maps[index]['finalPrice'] ?? 0,
          date: maps[index]['date'],
          id: maps[index]['id'],
          Purchaseprice: maps[index]['purchaseprice']
      );
    });

    productList.sort((a, b) => a.date.compareTo(b.date));
    // Reverse the order of the list to display the latest input at the top
    return productList.reversed.toList();
  }

  Future<void> syncSellProductsDataToLocalDatabase(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(key) ?? '';
    final DatabaseReference firebaseRef = FirebaseDatabase.instance.reference().child(uid).child('Sell_Product');
    try {
      List<SellProduct> existingProducts = await queryAllProducts();
      if (existingProducts.isEmpty) {
        DatabaseEvent snapshot = await firebaseRef.once();
        if (snapshot.snapshot.value != null) {
          if(snapshot.snapshot.value is Map){
            Map<dynamic, dynamic> data = snapshot.snapshot.value as Map<dynamic, dynamic>;
            data.forEach((key, value) async {
              if (value != null && value is Map<dynamic, dynamic>) {
                SellProduct sellProduct = SellProduct(
                  ProductName: value['itemName'],
                  SalePrice: value['salePrice'].toDouble(),
                  Quentity: value['quantity'],
                  FinalPrice: value['finalPrice'].toDouble(),
                  date: value['date'],
                  Purchaseprice: value['purchaseprice'].toDouble(),
                );
                await _database.insert(
                  'sellproduct',
                  sellProduct.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
                print('Done');
              }
            });
            Get.snackbar('Notice', 'Sell-List Sync Successfully');
          }
        }
      } else {
        Get.snackbar('Notice', 'Database already contains data');
      }
    } catch (error) {
      print('Error syncing Firebase data to SQLite for sellproduct: $error');
    }
  }



}
