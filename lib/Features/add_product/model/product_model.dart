class Product {
  final String itemName;
  final double salePrice;
  final double purchasePrice;
  final int openingStock;
  final int lowStock;
  final String date;
  final int id;

  Product({
    required this.itemName,
    required this.salePrice,
    required this.purchasePrice,
    required this.openingStock,
    required this.lowStock,
    required this.date,
    this.id=0,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      'openingStock': openingStock,
      'lowStock': lowStock,
      'date': date,
    };
  }
}