class ProductModel {
  ProductModel({
    this.productId,
    this.title,
    this.quantity,
    this.price,
    this.manufacturerDate,
    this.expiredDate,
    this.deliveryManID = "-1",
    this.distributorsID = "-1",
    this.status = 0,
  });

  ProductModel.fromJson(dynamic json) {
    productId = json['product_id'];
    title = json['title'];
    quantity = json['quantity'];
    price = json['price'];
    manufacturerDate = json['manufacturer_date'];
    distributorsID = json['distributorsID'];
    expiredDate = json['expired_date'];
    status = json['status'];
    deliveryManID = json['deliveryManID'];
  }

  int? productId;
  String? title;
  int? quantity;
  double? price;
  String? manufacturerDate;
  String? expiredDate;
  String? deliveryManID;
  String? distributorsID;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['title'] = title;
    map['quantity'] = quantity;
    map['price'] = price;
    map['status'] = status;
    map['distributorsID'] = distributorsID;
    map['deliveryManID'] = deliveryManID;
    map['manufacturer_date'] = manufacturerDate;
    map['expired_date'] = expiredDate;
    return map;
  }
}
