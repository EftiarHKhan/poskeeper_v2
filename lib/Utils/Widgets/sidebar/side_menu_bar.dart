import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/Features/pdf/controller/pdf_controller.dart';
import 'package:stormen/Repository/authentication_repository/authentication_repository.dart';
import 'package:stormen/Utils/Widgets/sidebar/widget/sync_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenuBar extends StatelessWidget {
  SideMenuBar({Key? key}) : super(key: key);

  final SyncController syncController = Get.put(SyncController());
  final PdfController pdfController = Get.put(PdfController());
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;


  void _openPlayStoreDevAccount() async {
    const playStoreDevAccountUrl = 'https://play.google.com/store/apps/dev?id=5551015295329500291';
    if (await canLaunch(playStoreDevAccountUrl)) {
      await launch(playStoreDevAccountUrl);
    } else {
      throw 'Could not launch $playStoreDevAccountUrl';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FooterView(
        footer: new Footer(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text('Developer : B.M.Samiul Haque Real'),
              Text('Version :1.0.1')
            ],
          )
        ),
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(
              "Stormen",
              style: TextStyle(fontSize: 24,color: Colors.white),
            ),
            accountEmail: Text("Groceries Management",style: TextStyle(fontSize: 13,color: Colors.white),),
            currentAccountPicture: ClipOval(
            ),
            decoration: BoxDecoration(
                color: Colors.blueAccent,
            ),
          ),
          ListTile(
            leading: RotationTransition(
                turns: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(syncController.animationController),
                child: const Icon(LineAwesomeIcons.sync_icon),
              ),
            title: const Text(
              "Sync",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () async {
              //syncController.startRotation();
              await databaseHelper.syncDataToFirebase(context);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(LineAwesomeIcons.pdf_file),
            title: const Text(
              "Stock List Download",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              pdfController.StockList(context);
            },
            trailing: Icon(LineAwesomeIcons.download,size: 15,),
          ),
          Divider(),
          ListTile(
            leading: const Icon(LineAwesomeIcons.pdf_file),
            title: const Text(
              "Daily Sells Download",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              pdfController.DailyPdf(context);
            },
            trailing: Icon(LineAwesomeIcons.download,size: 15,),
          ),
          ListTile(
            leading: const Icon(LineAwesomeIcons.pdf_file),
            title: const Text(
              "Monthly Sells Download",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              pdfController.MonthlyPdf(context);
            },
            trailing: Icon(LineAwesomeIcons.download,size: 15,),
          ),
          ListTile(
            leading: const Icon(LineAwesomeIcons.pdf_file),
            title: const Text(
              "Yearly Sells Download",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              pdfController.YearlyPdf(context);
            },
            trailing: Icon(LineAwesomeIcons.download,size: 15,),
          ),

          Divider(),
          ListTile(
            leading: const Icon(LineAwesomeIcons.star),
            title: const Text(
              "Rate This App",
              style: TextStyle(fontSize: 15),
            ),
            onTap: (){
              StoreRedirect.redirect(androidAppId: 'com.resoftltd.diucgpa');
            },
          ),
          ListTile(
            leading: const Icon(LineAwesomeIcons.share),
            title: const Text(
              "Share App",
              style: TextStyle(fontSize: 15),
            ),
            onTap: (){
              Share.share('com.resoftltd.diucgpa');
            },
          ),
          ListTile(
            leading: const Icon(LineAwesomeIcons.android),
            title: const Text(
              "More App",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              _openPlayStoreDevAccount();
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(LineAwesomeIcons.alternate_sign_out),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 15,color: Colors.red),
            ),
            onTap: (){
              AuthenticationRepository.instance.logout();
            },
          ),

        ],
      ),
    );
  }
}
