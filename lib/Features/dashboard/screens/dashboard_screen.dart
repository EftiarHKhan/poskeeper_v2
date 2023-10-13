import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Features/dashboard/screens/buy_sell_screen.dart';
import 'package:stormen/Features/dashboard/screens/profile_screen.dart';
import 'package:stormen/Features/dashboard/screens/stock_screen.dart';

import '../../../Utils/Widgets/appbar/home_appbar.dart';
import '../../../Utils/Widgets/sidebar/side_menu_bar.dart';
import 'details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  var _page = 0;
  final pages = [DetailsScreen(),StockScreen(),BuySellScreen(),ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        drawer: SideMenuBar(),
        bottomNavigationBar: Container(
          color: Colors.blueAccent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
            child: GNav(
              backgroundColor: Colors.blueAccent,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.blue.shade800,
              gap: 8,
              onTabChange: (index){
                setState(() {
                  _page=index;
                });
              },
              padding: EdgeInsets.all(16),
              tabs: const [
                GButton(icon: LineAwesomeIcons.border_all,text: 'Dashboard',),
                GButton(icon: LineAwesomeIcons.bar_chart_1,text: 'Stock Management',),
                GButton(icon: LineAwesomeIcons.shopping_cart,text: 'Add / Sell Product',),
                GButton(icon: LineAwesomeIcons.user,text: 'Profile',),
              ],
            ),
          ),
        ),
        body: pages[_page],

      ),
    );
  }
}
