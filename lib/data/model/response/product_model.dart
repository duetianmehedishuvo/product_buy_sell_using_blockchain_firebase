class ProductModel {
  ProductModel({
    this.productId,
    this.title,
    this.quantity,
    this.price,
    this.manufacturerDate,
    this.expiredDate,
    this.retailerID = "-1",
    this.customerID = "-1",
    this.distributorsID = "-1",
    this.manufacturerVerifiedStatus = true,
    this.isAssignDistributor = false,
    this.distributorsVerifiedStatus = false,
    this.isAssignRetailer = false,
    this.retailerVerifiedStatus = false,
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
    retailerID = json['retailerID'];
    customerID = json['customerID'];
    manufacturerVerifiedStatus = json['manufacturerVerifiedStatus'];
    isAssignDistributor = json['isAssignDistributor'];
    distributorsVerifiedStatus = json['distributorsVerifiedStatus'];
    isAssignRetailer = json['isAssignRetailer'];
    retailerVerifiedStatus = json['retailerVerifiedStatus'];
  }

  int? productId;
  String? title;
  int? quantity;
  double? price;
  String? manufacturerDate;
  String? expiredDate;
  String? retailerID;
  String? distributorsID;
  String? customerID;
  bool? manufacturerVerifiedStatus;
  bool? isAssignDistributor;
  bool? distributorsVerifiedStatus;
  bool? isAssignRetailer;
  bool? retailerVerifiedStatus;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['title'] = title;
    map['quantity'] = quantity;
    map['price'] = price;
    map['status'] = status;
    map['distributorsID'] = distributorsID;
    map['retailerID'] = retailerID;
    map['manufacturer_date'] = manufacturerDate;
    map['expired_date'] = expiredDate;
    map['customerID'] = customerID;
    map['manufacturerVerifiedStatus'] = manufacturerVerifiedStatus;
    map['isAssignDistributor'] = isAssignDistributor;
    map['distributorsVerifiedStatus'] = distributorsVerifiedStatus;
    map['isAssignRetailer'] = isAssignRetailer;
    map['retailerVerifiedStatus'] = retailerVerifiedStatus;
    return map;
  }
}
