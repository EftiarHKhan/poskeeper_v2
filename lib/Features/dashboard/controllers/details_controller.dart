import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/DB_Helper/sell_product/sell_db.dart';
import 'package:stormen/Features/add_product/model/product_model.dart';
import 'package:stormen/Features/sell_product/model/sell_product_model.dart';

class DetailsController extends GetxController{

  final DatabaseHelperSell databaseHelper = DatabaseHelperSell.instance;

  RxList<SellProduct> productList = RxList<SellProduct>();
  RxList<SellProduct> foundUsers = RxList<SellProduct>();


  Future<void> fetchData() async {
    productList.assignAll(await databaseHelper.queryAllProducts());
    foundUsers.assignAll(productList);
    await calculateDailyTotal(foundUsers);
    await calculateMonthlyTotal(foundUsers,DateTime.now().month,DateTime.now().year);
    await calculateTodaysProfit(foundUsers,DateTime.now().day, DateTime.now().month, DateTime.now().year);
    await calculateMonthlyProfit(foundUsers);
  }

  Future<double> calculateDailyTotal(List<SellProduct> productList) async {
    double DailyTotal = 0.0;

    for (SellProduct product in productList) {
      List<String> dateParts = product.date.split('-');
      if (dateParts.length == 3) {
        String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
        DateTime parsedDate = DateTime.parse(formattedDateStr);
        if (parsedDate.day == DateTime.now().day && parsedDate.month == DateTime.now().month && parsedDate.year == DateTime.now().year) {
          DailyTotal += product.FinalPrice; // Assuming product.finalPrice is a valid property name.
        }
      }
    }

    return DailyTotal;
  }

  Future<double> calculateMonthlyTotal(List<SellProduct> productList, int month, int year) async {
    double MonthlyTotal = 0.0;

    for (SellProduct product in productList) {
      List<String> dateParts = product.date.split('-');
      if (dateParts.length == 3) {
        String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
        DateTime parsedDate = DateTime.parse(formattedDateStr);

        if (parsedDate.month == month && parsedDate.year == year) {
          MonthlyTotal += product.FinalPrice;
        }
      }
    }

    return MonthlyTotal;
  }

  Future<double> calculateTodaysProfit(List<SellProduct> productList, int day, int month, int year) async {
    double totalProfit = 0;

    try {
      // Fetch all products and store them in a map for quick access
      Map<String, double> purchasePrices = {};

      List<Product> allProducts = await DatabaseHelper.instance.queryAllProducts();
      for (Product product in allProducts) {
        purchasePrices[product.itemName] = product.purchasePrice;
      }

      for (SellProduct product in productList) {
        List<String> dateParts = product.date.split('-');
        if (dateParts.length == 3) {
          String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
          DateTime parsedDate = DateTime.parse(formattedDateStr);

          if (parsedDate.day == day && parsedDate.month == month && parsedDate.year == year) {
            double costPrice = purchasePrices[product.ProductName] ?? 0;
            double profit = product.FinalPrice - costPrice*product.Quentity;
            totalProfit += profit; // Accumulate the profit for each product
          }
        }
      }
    } catch (e) {
      // Handle any exceptions or errors here
      print("Error calculating daily profit: $e");
    }
    return totalProfit; // Return the total profit after the loop
  }

  Future<double> calculateMonthlyProfit(List<SellProduct> productList) async {
    double MonthlyProfit = 0.0;

    try {
      // Fetch all products and store them in a map for quick access
      Map<String, double> purchasePrices = {};

      List<Product> allProducts = await DatabaseHelper.instance.queryAllProducts();
      for (Product product in allProducts) {
        purchasePrices[product.itemName] = product.purchasePrice;
      }

      for (SellProduct product in productList) {
        List<String> dateParts = product.date.split('-');
        if (dateParts.length == 3) {
          String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
          DateTime parsedDate = DateTime.parse(formattedDateStr);

          if (parsedDate.month == DateTime.now().month && parsedDate.year == DateTime.now().year) {
            double costPrice = purchasePrices[product.ProductName] ?? 0;
            double profit = product.FinalPrice - costPrice * product.Quentity;
            MonthlyProfit += profit;
          }
        }
      }
    } catch (e) {
      // Handle any exceptions or errors here
      print("Error calculating monthly profit: $e");
    }
    return MonthlyProfit;
  }

  Future<List<FlSpot>> generateMonthlySalesData(List<SellProduct> productList) async {
    List<FlSpot> monthlyData = [];

    for (int month = 1; month <= 12; month++) {
      double monthlyTotal = await calculateMonthlyTotal(productList, month, DateTime.now().year);
      if (monthlyTotal < 0) {
        monthlyTotal = 0;
      }
      monthlyData.add(FlSpot(month.toDouble(), monthlyTotal));
    }

    return monthlyData;
  }

}