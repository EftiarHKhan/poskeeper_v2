import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stormen/Features/dashboard/controllers/details_controller.dart';
import 'package:stormen/Features/dashboard/screens/widgets/chart_titles_widget.dart';
import 'package:stormen/Utils/Widgets/appbar/home_appbar.dart';
import 'package:stormen/Utils/Widgets/sizebox/space_widget.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  final DetailsController detailsController = Get.put(DetailsController());

  @override
  void initState() {
    super.initState();
    // Initialize the database
    detailsController.databaseHelper.initializeDatabase().then((_) {
      // Fetch data from the database
      detailsController.fetchData();
      setState(() {
        detailsController.fetchData();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder<double>(
                                  future: detailsController.calculateDailyTotal(detailsController.productList),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Loading...', style: TextStyle(color: Colors.white));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                                    } else {
                                      return Column(
                                        children: [
                                          Text('৳ ${snapshot.data!.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                          space(5),
                                          Text("Today Sales", style: TextStyle(color: Colors.white)),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                      ,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder<double>(
                                  future: detailsController.calculateMonthlyTotal(detailsController.productList, DateTime.now().month, DateTime.now().year,),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Loading...', style: TextStyle(color: Colors.white));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                                    } else {
                                      return Column(
                                        children: [
                                          Text('৳ ${snapshot.data?.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                          space(5),
                                          Text("Monthly Sales", style: TextStyle(color: Colors.white)),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                      ,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder<double>(
                                  future: detailsController.calculateTodaysProfit(detailsController.foundUsers, DateTime.now().day, DateTime.now().month, DateTime.now().year,),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Loading...', style: TextStyle(color: Colors.white));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                                    } else {
                                      return Column(
                                        children: [
                                          Text('৳ ${snapshot.data?.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                          space(5), // Use SizedBox instead of `space` for spacing
                                          Text("Today Profit", style: TextStyle(color: Colors.white)),
                                        ],
                                      );
                                    }
                                  },
                                ),
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
                        color: Colors.teal.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder<double>(
                                  future: detailsController.calculateMonthlyProfit(detailsController.productList),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Loading...', style: TextStyle(color: Colors.white));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                                    } else {
                                      return Column(
                                        children: [
                                          Text('৳ ${snapshot.data!.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                          space(5),
                                          Text("Monthly Profit", style: TextStyle(color: Colors.white)),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                      ,
                    ),
                  ),
                ),
              ],
            ),
            space(8),
            Padding(
                padding: const EdgeInsets.all(12),
                child: Text("Sells Overview",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Schyler'),)
            ),
            space(10),
            Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FutureBuilder<double>(
                  future: detailsController.calculateMonthlyTotal(detailsController.productList, DateTime.now().month, DateTime.now().year,),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while waiting.
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FutureBuilder<List<FlSpot>>(
                        future: detailsController.generateMonthlySalesData(detailsController.productList),
                        builder: (context, spotsSnapshot) {
                          if (spotsSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (spotsSnapshot.hasError) {
                            return Text('Error: ${spotsSnapshot.error}');
                          } else {
                            return LineChart(
                              LineChartData(
                                minX: 1, // Months are usually represented with a 1-based index.
                                maxX: 12,
                                minY: 0,
                                maxY: snapshot.data! * 2, // Use the result of the calculation here.
                                titlesData: LineTitles.getTitleData(),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spotsSnapshot.data!,
                                    isCurved: true,
                                    color: Color(0xff3aa94b),
                                    dotData: FlDotData(show: true),
                                    barWidth: 3,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Color(0xff3aa94b).withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            )
            ,
            space(10),
            Padding(
                padding: const EdgeInsets.all(12),
                child: Text("Selling Product List",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Schyler'),)
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                detailsController.foundUsers.isNotEmpty
                    ? Container(
                  height: MediaQuery.of(context).size.height-HomeAppBar().preferredSize.height -205,
                  child: Obx(()=>
                    ListView.builder(
                      itemCount: detailsController.foundUsers.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(position: index,
                            child:SlideAnimation(
                              child: FadeInAnimation(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){

                                      },
                                      child: Container(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: 12),
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          //  width: SizeConfig.screenWidth * 0.78,
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
                                                    detailsController.foundUsers[index].ProductName,
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
                                                      space2(4),
                                                      Text(
                                                        "Selling Price : ${detailsController.foundUsers[index].SalePrice}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                          TextStyle(fontSize: 13, color: Colors.grey[100]),
                                                        ),
                                                      ),
                                                      space2(4),
                                                      Text(
                                                        ", Purchase Price : ${detailsController.foundUsers[index].Purchaseprice}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                          TextStyle(fontSize: 13, color: Colors.grey[100]),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  Text(
                                                    "Quentity : ${detailsController.foundUsers[index].Quentity} , Total Price : ${detailsController.foundUsers[index].FinalPrice}",
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
                                                detailsController.foundUsers[index].date,
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
                  ),
                )
                    : Center(
                  child: Text('No products available.'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


