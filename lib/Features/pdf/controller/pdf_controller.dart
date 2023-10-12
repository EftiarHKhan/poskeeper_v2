import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/DB_Helper/sell_product/sell_db.dart';
import 'package:stormen/Features/add_product/model/product_model.dart';
import 'package:stormen/Features/dashboard/controllers/details_controller.dart';
import 'package:stormen/Features/pdf/controller/calculation_controller.dart';
import 'package:stormen/Features/pdf/screen/pdf_screen.dart';
import 'package:stormen/Features/sell_product/model/sell_product_model.dart';

class PdfController extends GetxController{

  final CalculationController calculationController = Get.put(CalculationController());
  final DetailsController detailsController = Get.put(DetailsController());



  Future<void> DailyPdf(BuildContext context) async {

    DatabaseHelperSell _databaseHelper = DatabaseHelperSell.instance;
    final now = new DateTime.now();
    final doc = pw.Document();

    final List<SellProduct> productList = await _databaseHelper.queryAllProducts();

    double todaysProfit = await detailsController.calculateTodaysProfit(
      productList,
      DateTime.now().day,
      DateTime.now().month,
      DateTime.now().year,
    );
    double todayssells = await detailsController.calculateDailyTotal(productList);

    final filteredProductList = productList.where((product) {// Debugging: Check each product's date
      final productDateParts = product.date.split('-');
      if (productDateParts.length == 3) {
        final day = int.tryParse(productDateParts[0]);
        final month = int.tryParse(productDateParts[1]);
        final year = int.tryParse(productDateParts[2]);
        if (day != null && month != null && year != null) {
          final productDate = DateTime(year, month, day);// Debugging: Check the parsed date
          // Check if the product's date is on the same day as the desired date
          return productDate.year == now.year &&
              productDate.month == now.month &&
              productDate.day == now.day;
        }
      }
      return false;
    }).toList();

    final tableData = ['Product Name', 'Sale Price', 'Quentity', 'Total Price', 'Date'];
    final tableData2 = ['Total Sell: ${todayssells}','Total Profit: ${todaysProfit}'];


    final table = pw.Table.fromTextArray(
      headers: tableData,
      data: [
        // To display the header row
        for (var product in filteredProductList)
          [product.ProductName, product.SalePrice.toString(), product.Quentity.toString(), product.FinalPrice.toString(), product.date],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
        color: PdfColors.grey300,
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );
    final table2 = pw.Table.fromTextArray(
      headers: tableData2,
      data:[],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [pw.Text("Daily Sells Overview",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 19)),
            pw.Text("Generated by 'Stormen'"),
            pw.Text("Date : "+DateFormat('dd-MM-yyyy').format(now),),
            pw.SizedBox(height: 10),
            pw.Text("Developed by ReSoft Ltd"),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table2,
              ),
            )
            // Add more content widgets here for each page as needed
          ];
        },
      ),
    );
    Get.to(PdfScreen(doc: doc));
  }

  Future<void> MonthlyPdf(BuildContext context) async {
    DatabaseHelperSell _databaseHelper = DatabaseHelperSell.instance;
    final now = new DateTime.now();
    final doc = pw.Document();

    final List<SellProduct> productList = await _databaseHelper.queryAllProducts(); // Replace this with the desired date


    double monthlyProfit = await detailsController.calculateMonthlyProfit(productList);
    double monthlysells = await detailsController.calculateMonthlyTotal(productList, DateTime.now().month, DateTime.now().year);


    final filteredProductList = productList.where((product) {// Debugging: Check each product's date
      final productDateParts = product.date.split('-');
      if (productDateParts.length == 3) {
        final month = int.tryParse(productDateParts[1]);
        final year = int.tryParse(productDateParts[2]);
        if (month != null && year != null) {
          final productDate = DateTime(year, month);// Debugging: Check the parsed date
          // Check if the product's date is on the same day as the desired date
          return productDate.year == now.year &&
              productDate.month == now.month;
        }
      }
      return false;
    }).toList();

    final tableData = ['Product Name', 'Sale Price', 'Quentity', 'Total Price', 'Date'];
    final tableData2 = ['Total Sell: ${monthlysells}','Total Profit: ${monthlyProfit}'];


    final table = pw.Table.fromTextArray(
      headers: tableData,
      data: [
        // To display the header row
        for (var product in filteredProductList)
          [product.ProductName, product.SalePrice.toString(), product.Quentity.toString(), product.FinalPrice.toString(), product.date],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
        color: PdfColors.grey300,
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    final table2 = pw.Table.fromTextArray(
      headers: tableData2,
      data:[],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [pw.Text("Monthly Sells Overview",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 19)),
            pw.Text("Generated by 'Stormen'"),
            pw.Text("Date : "+DateFormat('dd-MM-yyyy').format(now),),
            pw.SizedBox(height: 10),
            pw.Text("Developed by ReSoft Ltd"),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table2,
              ),
            )
            // Add more content widgets here for each page as needed
          ];
        },
      ),
    );
    Get.to(PdfScreen(doc: doc));
  }

  Future<void> YearlyPdf(BuildContext context) async {
    DatabaseHelperSell _databaseHelper = DatabaseHelperSell.instance;
    final now = new DateTime.now();
    final doc = pw.Document();


    final List<SellProduct> productList = await _databaseHelper.queryAllProducts();

    double allsProfit = await calculationController.calculateYearlyProfit(productList, DateTime.now().year);
    double allssells = await calculationController.calculateYearlyTotal(productList,  DateTime.now().year);

    final filteredProductList = productList.where((product) {// Debugging: Check each product's date
      final productDateParts = product.date.split('-');
      if (productDateParts.length == 3) {
        final day = int.tryParse(productDateParts[0]);
        final month = int.tryParse(productDateParts[1]);
        final year = int.tryParse(productDateParts[2]);
        if (day != null && month != null && year != null) {
          final productDate = DateTime(year);// Debugging: Check the parsed date
          return productDate.year == now.year;
        }
      }
      return false;
    }).toList();

    final tableData = ['Product Name', 'Sale Price', 'Quentity', 'Total Price', 'Date'];
    final tableData2 = ['Total Sell: ${allssells}','Total Profit: ${allsProfit}'];

    final table = pw.Table.fromTextArray(
      headers: tableData,
      data: [
        // To display the header row
        for (var product in filteredProductList)
          [product.ProductName, product.SalePrice.toString(), product.Quentity.toString(), product.FinalPrice.toString(), product.date],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
        color: PdfColors.grey300,
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    final table2 = pw.Table.fromTextArray(
      headers: tableData2,
      data:[],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [pw.Text("Yearly Sells Overview",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 19)),
            pw.Text("Generated by 'Stormen'"),
            pw.Text("Date : "+DateFormat('dd-MM-yyyy').format(now),),
            pw.SizedBox(height: 10),
            pw.Text("Developed by ReSoft Ltd"),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table2,
              ),
            )
            // Add more content widgets here for each page as needed
          ];
        },
      ),
    );

    Get.to(PdfScreen(doc: doc));
  }

  Future<void> StockList(BuildContext context) async {

    DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    final now = new DateTime.now();
    final doc = pw.Document();


    final List<Product> stockList = await _databaseHelper.queryAllProducts();


    final tableData = ['Product Name', 'Purchase Price', 'Quantity','Stock Value', 'Date'];

    final table = pw.Table.fromTextArray(
      headers: tableData,
      data: [
        // To display the header row
        for (var product in stockList)
          [product.itemName, product.purchasePrice, product.openingStock,product.openingStock * product.purchasePrice, product.date],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
        color: PdfColors.grey300,
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [pw.Text("Stock Product List",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 19)),
            pw.Text("Generated by 'Stormen'"),
            pw.Text("Date : "+DateFormat('dd-MM-yyyy').format(now),),
            pw.SizedBox(height: 10),
            pw.Text("Developed by ReSoft Ltd"),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table,
              ),
            ),
          ];
        },
      ),
    );

    Get.to(PdfScreen(doc: doc));
  }

  Future<void> Receipt(BuildContext context,SellProduct product) async {
    final now = new DateTime.now();
    final doc = pw.Document();


    final tableData = ['Product Name', 'Quantity', 'Unit Price', 'Total'];


    final table = pw.Table.fromTextArray(
      headers: tableData,
      data: [
        [product.ProductName, product.Quentity, product.SalePrice, product.Quentity * product.SalePrice],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(),
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(2),
        color: PdfColors.grey300,
      ),
      cellAlignment: pw.Alignment.center, // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    final table2 = pw.Table.fromTextArray(
      data: [
        ['', '',''],
        ['Subtotal', ':','__'],
        ['Discount', ':','__'],
        ['Subtotal Less Discount',':','__'],
        ['Tax Rate',':','__'],
        ['Total Tax',':','__'],
        ['Shipping/Handling',':','__',],
        ['Balance Paid', ':','__'],
      ],
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide.none, // Remove horizontal borders within rows
        left: pw.BorderSide.none, // Remove the left border of the table
        right: pw.BorderSide.none, // Remove the right border of the table
        top: pw.BorderSide.none, // Remove the top border of the table
        bottom: pw.BorderSide.none, // Remove the bottom border of the table
      ), // Or any other alignment you prefer
      cellPadding: pw.EdgeInsets.all(5), // Add padding here
      // Add more styling options as needed
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [pw.Text("Store Name",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 25)),
            pw.SizedBox(height: 4),
            pw.Text("Address"),
            pw.SizedBox(height: 3),
            pw.Text("Email Address"),
            pw.SizedBox(height: 3),
            pw.Text("Phone Number"),
            pw.SizedBox(height: 3),
            pw.Text("Date : "+DateFormat('dd-MM-yyyy').format(now),),
            pw.SizedBox(height: 4),
            pw.Text("Generated by Stormen"),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table,
              ),
            ),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: table2,
              ),
            ),
            pw.SizedBox(height: 150),
            pw.Container(
              alignment: pw.Alignment.bottomCenter,
              margin: pw.EdgeInsets.only(top: 10.0),
              child: pw.Text('© 2020-2025, Resoft LTD . All rights reserved',
                  style: pw.TextStyle(fontSize: 12)),
            ),
          ];
        },
      ),
    );
    Get.to(PdfScreen(doc: doc));
  }




}