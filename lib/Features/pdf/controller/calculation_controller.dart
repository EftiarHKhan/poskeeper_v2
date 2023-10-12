import 'package:get/get.dart';
import 'package:stormen/DB_Helper/product/product_db.dart';
import 'package:stormen/Features/add_product/model/product_model.dart';
import 'package:stormen/Features/sell_product/model/sell_product_model.dart';

class CalculationController extends GetxController {

  Future<double> calculateYearlyProfit(List<SellProduct> productList, int year) async {
    double totalProfit = 0;
    try {
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

          if (parsedDate.year == year) {
            double costPrice = purchasePrices[product.ProductName] ?? 0; // Get the purchasePrice for the product
            double profit = product.FinalPrice - costPrice*product.Quentity;
            totalProfit += profit;
            print(totalProfit);
          }
        }
      }
    } catch (e) {
      print("Error calculating monthly profit: $e");
    }
    return totalProfit;
  }

  Future<double> calculateYearlyTotal(List<SellProduct> productList, int year) async {
    double total = 0;

    for (SellProduct product in productList) {
      List<String> dateParts = product.date.split('-');
      if (dateParts.length == 3) {
        String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
        DateTime parsedDate = DateTime.parse(formattedDateStr);

        if (parsedDate.year == year) {
          total += product.FinalPrice;
        }
      }
    }
    return total;
  }



}