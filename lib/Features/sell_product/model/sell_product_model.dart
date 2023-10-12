class SellProduct {
  final String ProductName;
  final double SalePrice;
  final int Quentity;
  final double FinalPrice;
  final String date;
  final double Purchaseprice;
  final int id;

  SellProduct({
    required this.ProductName,
    required this.SalePrice,
    required this.Quentity,
    required this.FinalPrice,
    required this.date,
    required this.Purchaseprice,
    this.id=0,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': ProductName,
      'salePrice': SalePrice,
      'quantity': Quentity,
      'finalPrice': FinalPrice,
      'date': date,
      'purchaseprice': Purchaseprice
    };
  }
}