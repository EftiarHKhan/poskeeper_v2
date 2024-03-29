import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/DB_Helper/sell_product/sell_db.dart';
import 'package:stormen/Features/authentication/screens/Welcome_Screen/welcome_screen.dart';
import 'package:stormen/Repository/authentication_repository/authentication_repository.dart';
import 'package:stormen/firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthenticationRepository()));
  await DatabaseHelper.instance.initializeDatabase();
  await DatabaseHelperSell.instance.initializeDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent.shade200),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

