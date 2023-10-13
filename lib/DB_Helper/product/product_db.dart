import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:stormen/Features/add_product/model/product_model.dart';

class DatabaseHelper {

  late Database _database;
  late DatabaseReference _databaseReference;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<void> initializeDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'allproductinsert1.db');

    // Rename the variable to avoid naming conflict
    bool exists = await databaseExists(databasePath);

    if (!exists) {
      _database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE allproduct(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT,
            salePrice DOUBLE,
            purchasePrice DOUBLE,
            openingStock INTEGER,
            lowStock INTEGER,
            date TEXT,
            image TEXT
          )
        ''');
        },
      );
    } else {
      _database = await openDatabase(databasePath);
    }
  }


  Future<void> insertProduct(Product product) async {

    //DatabaseReference firebaseRef = FirebaseDatabase.instance.reference().child('Device_ID');
    //String? deviceId = await getDeviceId();
    //String? deviceName = await getDeviceName();
    //firebaseRef.child(deviceName.toString()).set(deviceId);

    //_databaseReference = FirebaseDatabase.instance.ref().child('New_Products');
    await _database.insert(
      'allproduct',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //_databaseReference.child(product.itemName.toString()).set(product.toMap());
  }
  Future<String?> getDeviceName() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print(androidInfo.model);
        return androidInfo.model; // This will give you the device name on Android
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.name; // This will give you the device name on iOS
      }
    } catch (e) {
      // Handle any errors that might occur while getting the device name
      print('Error getting device name: $e');
    }
    return null; // Return null if the platform is not Android or iOS
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // This is the unique identifier for Android devices
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // This is the unique identifier for iOS devices
    }
    return null; // Return null if the platform is not Android or iOS
  }

  Future<List<Product>> queryAllProducts() async {
    List<Map<String, dynamic>> maps = await _database.query('allproduct');

    // Generate the list of products and sort it by 'id' in ascending order
    List<Product> productList = List.generate(maps.length, (index) {
      return Product(
        itemName: maps[index]['itemName'],
        salePrice: maps[index]['salePrice'],
        purchasePrice: maps[index]['purchasePrice'],
        openingStock: maps[index]['openingStock'],
        lowStock: maps[index]['lowStock'],
        date: maps[index]['date'],
        id: maps[index]['id'],
        image: maps[index]['image'],
      );
    });

    // Sort the list by 'id' in ascending order
    productList.sort((a, b) => a.date.compareTo(b.date));

    // Reverse the order of the list to display the latest input at the top
    return productList.toList();
  }


  Future<void> syncDataToFirebase(BuildContext context) async {
    // Reference to the Firebase node where products are stored
    DatabaseReference firebaseRef = FirebaseDatabase.instance.reference().child('Sync_Product');

    try {
      // Query all products from Firebase and remove them
      // Query all products from SQLite
      final List<Product> products = await queryAllProducts();
      if (products.isEmpty) {
        Get.snackbar('Notice', 'Product List is Empty');
      }else{
        await firebaseRef.remove();
        // Iterate through each product and sync it with Firebase
        for (Product product in products) {
          try {
            // Insert the product as a new record in Firebase
            await firebaseRef.child(product.id.toString()).set(product.toMap());
          } catch (error) {
            print('Error syncing product to Firebase: ${error.toString()}');
          }
        }
        Get.snackbar('Notice', 'Product Sync Successfully');
      }

    } catch (error) {
      print('Error removing existing data from Firebase: ${error.toString()}');
    }
  }


  Future<void> syncFirebaseDataToLocalDatabase(BuildContext context) async {
    final DatabaseReference firebaseRef = FirebaseDatabase.instance.reference().child('Sync_Product');
    try {
      List<Product> existingProducts = await queryAllProducts();
      if (existingProducts.isEmpty) {
        DatabaseEvent snapshot = await firebaseRef.once();
        if (snapshot.snapshot.value != null && snapshot.snapshot.value is List<dynamic>) {
          List<dynamic> data = snapshot.snapshot.value as List<dynamic>;
          for (var value in data) {
            // Add a null check before accessing properties
            if (value != null) {
              Product product = Product(
                itemName: value['itemName'],
                salePrice: value['salePrice'].toDouble(),
                purchasePrice: value['purchasePrice'].toDouble(),
                openingStock: value['openingStock'],
                lowStock: value['lowStock'],
                date: value['date'],
                image: value['image'],
              );
              await _database.insert(
                'allproduct',
                product.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          };
          Get.snackbar('Notice', 'Product Sync Successfully');
        }
      } else {
        Get.snackbar('Notice', 'Database already contains data');
      }
    } catch (error) {
      print('Error syncing Firebase data to SQLite: $error');
    }
  }



  Future<List<String>> queryDistinctItemNames() async {
    List<Map<String, dynamic>> maps = await _database.query('allproduct');

    // Use a Set to store unique item names
    Set<String> uniqueItemNames = {};

    for (int index = 0; index < maps.length; index++) {
      String itemName = maps[index]['itemName'];
      uniqueItemNames.add(itemName);
    }

    // Convert the Set to a List to return the distinct item names
    List<String> distinctItemNames = uniqueItemNames.toList();

    return distinctItemNames.reversed.toList();
  }


}
