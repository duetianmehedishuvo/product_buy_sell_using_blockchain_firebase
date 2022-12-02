class ProductModel {
  ProductModel({
    this.productId,
    this.title,
    this.quantity,
    this.price,
    this.manufacturerDate,
    this.expiredDate,
  });

  ProductModel.fromJson(dynamic json) {
    productId = json['product_id'];
    title = json['title'];
    quantity = json['quantity'];
    price = json['price'];
    manufacturerDate = json['manufacturer_date'];
    expiredDate = json['expired_date'];
  }

  int? productId;
  String? title;
  int? quantity;
  double? price;
  String? manufacturerDate;
  String? expiredDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['title'] = title;
    map['quantity'] = quantity;
    map['price'] = price;
    map['manufacturer_date'] = manufacturerDate;
    map['expired_date'] = expiredDate;
    return map;
  }
}
